from flask import Blueprint, render_template

from li_metabase.utils import Dashboard, get_dashboard_id_from_url, build_iframe_url


PERMITS_DASHBOARDS = [
    Dashboard('Permit Volumes and Revenues', 'volume-and-revenues', 39),
    Dashboard('Permits: OTC vs Reviewed', 'otc-vs-reviewed', 40),
    Dashboard('Accelerated Review Permits', 'accelerated-review', 41),
]

bp = Blueprint('permits', __name__)

@bp.route('/permits/<dashboard_url>')
def permits(dashboard_url):
    global PERMITS_DASHBOARDS

    dashboard_id = get_dashboard_id_from_url(dashboard_url, PERMITS_DASHBOARDS)

    payload = {
        'resource': {'dashboard': dashboard_id},
        'params': {}
    }

    iframe_url = build_iframe_url(payload)

    return render_template('dashboard.html', iframe_url=iframe_url)
