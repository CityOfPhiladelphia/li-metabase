from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, get_dashboard_id_from_url, build_iframe_url


VIOLATIONS_DASHBOARDS = [
    Dashboard('Unsafe Violations', 'unsafe', 42),
    Dashboard('Imminently Dangerous Violations', 'imminently-dangerous', 36),
]

bp = Blueprint('violations', __name__)

@bp.route('/violations/<dashboard_url>')
def violations(dashboard_url):
    global VIOLATIONS_DASHBOARDS

    dashboard_id = get_dashboard_id_from_url(dashboard_url, VIOLATIONS_DASHBOARDS)

    payload = {
        'resource': {'dashboard': dashboard_id},
        'params': {}
    }

    iframe_url = build_iframe_url(payload)

    return render_template('dashboard.html', iframe_url=iframe_url)
