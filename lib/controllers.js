'use strict';

const db = require.main.require('./src/database');
const user = require.main.require('./src/user');
const utils = require.main.require('./src/utils');
const batch = require.main.require('./src/batch');

const Controllers = module.exports;

Controllers.renderAdminPage = async function (req, res/* , next */) {
	let users = []
	let start = 0;
	let end = 0;
	if (req.query.end) {
		end = (new Date(req.query.end)).getTime();
	} else {
		end = '+inf';
	}
	if (req.query.start) {
		start = (new Date(req.query.start)).getTime();
	}
	if (start && end) {
		const pids = await db.getSortedSetRangeByScore(`posts:pid`, 0, -1, start, end);
		const uids = Object.create(null);
		await batch.processArray(pids, async (pids) => {
			const postData = await db.getObjectsFields(pids.map(pid => `post:${pid}`), ['pid', 'uid']);
			postData.forEach((p) => {
				if (p && p.uid) {
					if (!uids[p.uid]) {
						uids[p.uid] = [];
					}
					uids[p.uid].push(p.pid);
				}
			});
		}, {
			batch: 500,
		});

		users = await loadUserInfo(req.uid, Object.keys(uids));
		users.forEach((u) => {
			if (u && uids[u.uid]) {
				u.postcount = uids[u.uid].length;
			}
		});
		users.sort((a, b) => b.postcount - a.postcount);
	}
	res.render('admin/plugins/user-post-counts', {
		title: 'User Post Counts',
		users: users,
		start: req.query.start || '',
		end: req.query.end || '',
	});
};

async function loadUserInfo(callerUid, uids) {
	async function getIPs() {
		return await Promise.all(uids.map(uid => db.getSortedSetRevRange(`uid:${uid}:ip`, 0, 4)));
	}
	async function getConfirmObjs() {
		const keys = uids.map(uid => `confirm:byUid:${uid}`);
		const codes = await db.mget(keys);
		const confirmObjs = await db.getObjects(codes.map(code => `confirm:${code}`));
		return uids.map((uid, index) => confirmObjs[index]);
	}
	const userFields = [
		'uid', 'username', 'userslug', 'email', 'postcount', 'joindate', 'banned',
		'reputation', 'picture', 'flags', 'lastonline', 'email:confirmed',
	];
	const [isAdmin, userData, lastonline, confirmObjs, ips] = await Promise.all([
		user.isAdministrator(uids),
		user.getUsersWithFields(uids, userFields, callerUid),
		db.sortedSetScores('users:online', uids),
		getConfirmObjs(),
		getIPs(),
	]);
	userData.forEach((user, index) => {
		if (user) {
			user.administrator = isAdmin[index];
			const timestamp = lastonline[index] || user.joindate;
			user.lastonline = timestamp;
			user.lastonlineISO = utils.toISOString(timestamp);
			user.ips = ips[index];
			user.ip = ips[index] && ips[index][0] ? ips[index][0] : null;
			user.emailToConfirm = user.email;
			if (confirmObjs[index] && confirmObjs[index].email) {
				const confirmObj = confirmObjs[index];
				user['email:expired'] = !confirmObj.expires || Date.now() >= confirmObj.expires;
				user['email:pending'] = confirmObj.expires && Date.now() < confirmObj.expires;
				user.emailToConfirm = confirmObj.email;
			}
		}
	});
	return userData;
}
