"""InnerJapi 本机 HTTP 回显测试。仅绑定回环地址，Ctrl+C 退出。"""
import argparse
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer


class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path != "/test":
            self.send_error(404)
            return
        try:
            size = int(self.headers.get("Content-Length", "0"))
        except ValueError:
            self.send_error(400)
            return
        if not 0 <= size <= 65536:
            self.send_error(413)
            return
        self.connection.settimeout(10)
        body = self.rfile.read(size)
        print(f"POST {self.path} Content-Type={self.headers.get('Content-Type')} body={body!r}", flush=True)
        time.sleep(self.server.response_delay)
        response = b"ok:" + body
        try:
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(response)))
            self.end_headers()
            self.wfile.write(response)
        except (BrokenPipeError, ConnectionResetError, TimeoutError):
            print("客户端已断开，响应未送达", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=18080)
    parser.add_argument("--delay", type=float, default=0, help="延迟响应秒数，用于测试旧回调")
    args = parser.parse_args()
    if args.delay < 0:
        parser.error("delay 不能小于零")
    with ThreadingHTTPServer(("127.0.0.1", args.port), Handler) as server:
        server.response_delay = args.delay
        print(f"监听 http://127.0.0.1:{args.port}/test，延迟 {args.delay} 秒；Ctrl+C 停止", flush=True)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
