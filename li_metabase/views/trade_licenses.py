from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


TRADE_LICENSES_DASHBOARDS = [
    Dashboard('Trade Licenses Active Jobs', 'active-jobs', 69),
    Dashboard('Trade Licenses Active Processes', 'active-processes', 71),
    Dashboard('Trade Licenses Expiration Dates', 'expiration-dates', 74),
    Dashboard('Trade Licenses Incomplete Processes', 'incomplete-processes', 75),
    Dashboard('Trade Licenses Job Volumes By Submission Type', 'job-volumes-by-submission-type', 73),
    Dashboard('Trade Licenses Revenue', 'revenue', 43),
    Dashboard('Trade Licenses Submittal Types', 'submittal-types', 44),
    Dashboard('Trade Licenses Volumes', 'volumes', 35),
]

bp = Blueprint('trade_licenses', __name__)

@bp.route('/tl/<dashboard_url>')
@auth.login_required
def trade_licenses(dashboard_url):
    global TRADE_LICENSES_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, TRADE_LICENSES_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')
