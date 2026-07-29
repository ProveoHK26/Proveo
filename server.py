from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import os


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.abspath(os.path.dirname(__file__)), **kwargs)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', '3000'))
    server = ThreadingHTTPServer(('0.0.0.0', port), Handler)
    print(f'Servidor local listo en http://127.0.0.1:{port}')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('\nServidor detenido.')
        server.server_close()
