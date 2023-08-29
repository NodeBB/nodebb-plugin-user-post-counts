'use strict';

/*
	This file is located in the "modules" block of plugin.json
	It is only loaded when the user navigates to /admin/plugins/quickstart page
	It is not bundled into the min file that is served on the first load of the page.
*/

import { save, load } from 'settings';
import * as uploader from 'uploader';

export function init() {
	const oneMonthAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);
	const monthAgo = new Date(oneMonthAgo);
	if (!ajaxify.data.start) {
		$('form #start').val(monthAgo.toISOString().split('T')[0]);
	}
};
