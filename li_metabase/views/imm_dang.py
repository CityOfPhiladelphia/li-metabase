from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


IMM_DANG_DASHBOARDS = [
    Dashboard('Open Cases', 'open-cases', 153),
    Dashboard('Historical Violations', 'historical-violations', 190)
]

bp = Blueprint('imminently_dangerous', __name__)

@bp.route('/compliance-enforcement/imminently-dangerous/<dashboard_url>')
@auth.login_required
def imm_dang(dashboard_url):
    global IMM_DANG_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, IMM_DANG_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
