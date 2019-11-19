from flask import Blueprint, render_template, redirect

from li_metabase.utils import Dashboard, build_iframe_url_from_dashboard_url, DashboardNotFound
from li_metabase.auth import auth


CASES_VIOLATIONS_DASHBOARDS = [
    Dashboard('Violations', 'violations', 116),
    Dashboard('Cases', 'cases', 152),
    Dashboard('Case Contacts', 'case-contacts', 174)
]

bp = Blueprint('violations', __name__)

@bp.route('/cases-violations/<dashboard_url>')
@auth.login_required
def cases_violations(dashboard_url):
    global CASES_VIOLATIONS_DASHBOARDS

    iframe_url = build_iframe_url_from_dashboard_url(dashboard_url, CASES_VIOLATIONS_DASHBOARDS)

    return render_template('dashboard.html', iframe_url=iframe_url)

@bp.errorhandler(DashboardNotFound)
def handle_error(error):
    return render_template('error.html')

#Redirect old versions of URLs to new versions
@bp.route('/cases-violations/completed-case-inspections')
@auth.login_required
def redirect_completed_case_inspections():
    return redirect("/cases-violations/case-inspections/completed", code=301)

@bp.route('/cases-violations/oustanding-case-inspections')
@auth.login_required
def redirect_outstanding_case_inspections():
    return redirect("/cases-violations/case-inspections/outstanding", code=301)

@bp.route('/cases-violations/current-imminently-dangerous-properties')
@auth.login_required
def current_imminently_dangerous_properties():
    return redirect("/cases-violations/open-imminently-dangerous-cases", code=301)