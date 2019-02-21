from gevent.pywsgi import WSGIServer

from li_metabase import create_app


if __name__ == '__main__':
    app = create_app()
    http_server = WSGIServer(('0.0.0.0', 8000), app)
    http_server.serve_forever()