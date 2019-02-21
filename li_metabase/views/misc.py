from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, get_dashboard_id_from_url, build_iframe_url


MISC_DASHBOARDS = [
    Dashboard('Individual Workloads', 'individual-workloads', 49, {'process_completion_date': '2017-12-31~'}),
    Dashboard('Expiring Licenses with Tax Issues', 'expiring-licenses-with-tax-issues', 72),
    Dashboard('Public Demos', 'public-demos', 76, {'demolition_date': '2006-12-31~'}),
    Dashboard('Uninspected Service Requests', 'unispected-service-requests', 77, {'call_date': '2015-12-31~'}),
]

bp = Blueprint('misc', __name__)

@bp.route('/misc/<dashboard_url>')
def misc(dashboard_url):
    global MISC_DASHBOARDS

    dashboard_id = get_dashboard_id_from_url(dashboard_url, MISC_DASHBOARDS)

    payload = {
        'resource': {'dashboard': dashboard_id},
        'params': {}
    }

    iframe_url = build_iframe_url(payload)

    return render_template('dashboard.html', iframe_url=iframe_url)
