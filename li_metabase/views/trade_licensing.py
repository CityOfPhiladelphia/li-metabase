from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


TRADE_LICENSING_DASHBOARDS = [
    Dashboard('Trade Licensing Active Jobs', 'active-jobs', 69),
    Dashboard('Trade Licensing Active Processes', 'active-processes', 71),
    Dashboard('Expiring Trade Licensing', 'expiring-licenses', 74),
    Dashboard('Trade Licensing Incomplete Processes', 'incomplete-processes', 75),
    Dashboard('Trade Licensing Jobs By Submission Mode', 'submission-mode', 84),
    Dashboard('Trade Licensing Revenue', 'revenue', 43),
    Dashboard('Trade Licensing SLA', 'sla', 79),
    Dashboard('Trade Licensing Issued', 'issued', 35)
]

bp = Blueprint('trade_licensing', __name__)

@bp.route('/tl/<dashboard_url>')
@auth.login_required
def trade_licensing(dashboard_url):
    global TRADE_LICENSING_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, TRADE_LICENSING_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
