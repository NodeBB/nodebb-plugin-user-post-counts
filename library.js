'use strict';

const controllers = require('./lib/controllers');

const routeHelpers = require.main.require('./src/routes/helpers');

const plugin = module.exports;

plugin.init = async (params) => {
	const { router /* , middleware , controllers */ } = params;

	routeHelpers.setupAdminPageRoute(router, '/admin/plugins/user-post-counts', controllers.renderAdminPage);
};

plugin.addAdminNavigation = (header) => {
	header.plugins.push({
		route: '/plugins/user-post-counts',
		icon: 'fa-user',
		name: 'User Post Counts',
	});

	return header;
};

