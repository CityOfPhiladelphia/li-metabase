from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


UNSAFES_DASHBOARDS = [
    Dashboard('Open Cases', 'open-cases', 154),
    Dashboard('Historical Violations', 'historical-violations', 191)
]

bp = Blueprint('unsafes', __name__)

@bp.route('/compliance-enforcement/unsafes/<dashboard_url>')
@auth.login_required
def unsafes(dashboard_url):
    global UNSAFES_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, UNSAFES_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
