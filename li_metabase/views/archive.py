from flask import Blueprint, render_template, redirect

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


ARCHIVE_DASHBOARDS = [
    Dashboard('Violations', 'violations', 116),
    Dashboard('Permits and Inspections', 'tl-investigations-permits-and-inspections', 167),
]

bp = Blueprint('archive', __name__)

@bp.route('/archive/<dashboard_url>')
@auth.login_required
def archive(dashboard_url):
    global ARCHIVE_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, ARCHIVE_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')