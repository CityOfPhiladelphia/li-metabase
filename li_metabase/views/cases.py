from flask import Blueprint, render_template, redirect

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


CASES_DASHBOARDS = [
    Dashboard('All Eclipse', 'all-eclipse', 194),
    Dashboard('Open', 'open', 195)
]

bp = Blueprint('cases', __name__)

@bp.route('/compliance-enforcement/cases/<dashboard_url>')
@auth.login_required
def cases(dashboard_url):
    global CASES_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, CASES_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')

#Redirect old versions of URLs to new versions
@bp.route('/compliance-enforcement/cases/all-recent')
@auth.login_required
def cases_all_eclipse():
    return redirect("/compliance-enforcement/cases/all-eclipse", code=301)