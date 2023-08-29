<div class="d-flex flex-column gap-2 px-lg-4 h-100">
	<div component="settings/main/header" class="row border-bottom py-2 m-0 sticky-top acp-page-main-header align-items-center">
		<div class="col-12 col-md-6 px-0 mb-1 mb-md-0">
			<h4 class="fw-bold tracking-tight mb-0">{title}</h4>
		</div>
		<form class="col-md-6 d-flex flex-wrap gap-3 align-sm-items-center justify-content-end" method="GET">
			<div class="d-flex align-items-center gap-2">
				<label class="form-label mb-0" for="start">Start</label>
				<input type="date" class="form-control form-control-sm w-auto" id="start" name="start" value="{start}">
			</div>
			<div class="d-flex align-items-center gap-2">
				<label class="form-label mb-0" for="end">End</label>
				<input type="date" class="form-control form-control-sm w-auto" id="end" name="end" value="{end}">
			</div>
			<div class="">
				<button type="submit" class="btn btn-primary btn-sm" type="submit">Filter</button>
			</div>
		</form>
	</div>

	<div class="row m-0 flex-fill">
		<div id="spy-container" class="col-12 px-0 mb-4 flex-fill" tabindex="0">
			<div class="table-responsive flex-grow-1 h-100">
				<table class="table users-table text-sm">
					<thead>
						<tr>
							<th class="text-end text-muted">[[admin/manage/users:users.uid]]</th>
							<th class="text-muted">[[admin/manage/users:users.username]]</th>
							<th class="text-muted">[[admin/manage/users:users.email]]</th>
							<th class="text-muted">[[admin/manage/users:users.ip]]</th>
							<th data-sort="postcount" class="text-end text-nowrap">[[admin/manage/users:users.postcount]] {{{if sort_postcount}}}<i class="fa fa-sort-{{{if reverse}}}down{{{else}}}up{{{end}}}">{{{end}}}</th>
							<th data-sort="reputation" class="text-end text-nowrap">[[admin/manage/users:users.reputation]] {{{if sort_reputation}}}<i class="fa fa-sort-{{{if reverse}}}down{{{else}}}up{{{end}}}">{{{end}}}</th>
							<th data-sort="joindate" class="text-nowrap">[[admin/manage/users:users.joined]] {{{if sort_joindate}}}<i class="fa fa-sort-{{{if reverse}}}down{{{else}}}up{{{end}}}">{{{end}}}</th>
							<th data-sort="lastonline" class="text-nowrap">[[admin/manage/users:users.last-online]] {{{if sort_lastonline}}}<i class="fa fa-sort-{{{if reverse}}}down{{{else}}}up{{{end}}}">{{{end}}}</th>
						</tr>
					</thead>
					<tbody>
						{{{ each users }}}
						<tr class="user-row align-middle">
							<td class="text-end">{users.uid}</td>
							<td>
								<i title="[[admin/manage/users:users.banned]]" class="ban fa fa-gavel text-danger{{{ if !users.banned }}} hidden{{{ end }}}"></i>
								<i class="administrator fa fa-shield text-success{{{ if !users.administrator }}} hidden{{{ end }}}"></i>
								<a href="{config.relative_path}/user/{users.userslug}"> {users.username}</a>
							</td>
							<td class="text-nowrap ">
								<div class="d-flex flex-column gap-1">
									{{{ if (!./email && !./emailToConfirm) }}}
									<em class="text-muted">[[admin/manage/users:users.no-email]]</em>
									{{{ else }}}
									<span class="validated {{{ if !users.email:confirmed }}} hidden{{{ end }}}">
										<i class="fa fa-fw fa-check text-success" title="[[admin/manage/users:users.validated]]" data-bs-toggle="tooltip"></i>
										{{{ if ./email }}}{./email}{{{ end }}}
									</span>

									<span class="validated-by-admin hidden">
										<i class="fa fa-fw fa-check text-success" title="[[admin/manage/users:users.validated]]" data-bs-toggle="tooltip"></i>
										{{{ if ./emailToConfirm }}}{./emailToConfirm}{{{ end }}}
									</span>

									<span class="pending {{{ if !users.email:pending }}} hidden{{{ end }}}">
										<i class="fa fa-fw fa-clock-o text-warning" title="[[admin/manage/users:users.validation-pending]]" data-bs-toggle="tooltip"></i>
										{./emailToConfirm}
									</span>

									<span class="expired {{{ if !users.email:expired }}} hidden{{{ end }}}">
										<i class="fa fa-fw fa-times text-danger" title="[[admin/manage/users:users.validation-expired]]" data-bs-toggle="tooltip"></i>
										{./emailToConfirm}
									</span>

									<span class="notvalidated {{{ if (users.email:expired || (users.email:pending || users.email:confirmed)) }}} hidden{{{ end }}}">
										<i class="fa fa-fw fa-times text-danger" title="[[admin/manage/users:users.not-validated]]" data-bs-toggle="tooltip"></i>
										{./emailToConfirm}
									</span>
									{{{ end }}}
								</div>
							</td>
							<td>
								{{{ if ./ips.length }}}
								<div class="dropdown">
									<button class="btn btn-light btn-sm" data-bs-toggle="dropdown"><i class="fa fa-fw fa-list text-muted"></i></button>
									<ul class="dropdown-menu p-1">
										{{{ each ./ips }}}
										<li class="d-flex gap-1 {{{ if !@last }}}mb-1{{{ end }}}">
											<a class="dropdown-item rounded-1">{@value}</a>
											<button data-ip="{@value}" onclick="navigator.clipboard.writeText(this.getAttribute('data-ip'))" class="btn btn-light btn-sm"><i class="fa fa-copy"></i></button>
										</li>
										{{{ end }}}
									</ul>
								</div>
								{{{ end }}}
							</td>
							<td class="text-end">{formattedNumber(users.postcount)}</td>
							<td class="text-end" component="user/reputation" data-uid="{users.uid}">{formattedNumber(users.reputation)}</td>
							<td><span class="timeago" title="{users.joindateISO}"></span></td>
							<td><span class="timeago" title="{users.lastonlineISO}"></span></td>
						</tr>
						{{{ end }}}
					</tbody>
				</table>
			</div>

			<!-- IMPORT admin/partials/paginator.tpl -->
		</div>

	</div>
</div>
