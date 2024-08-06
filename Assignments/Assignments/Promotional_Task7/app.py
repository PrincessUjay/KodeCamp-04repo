  import os
  from http.server import SimpleHTTPRequestHandler, HTTPServer

  class MyHandler(SimpleHTTPRequestHandler):
      def do_GET(self):
          welcome_message = os.getenv('WELCOME_MESSAGE', "Hello, Welcome to KodeCamp DevOps Bootcamp!")
          secret_password = os.getenv('SECRET_PASSWORD', "No Secret")
          self.send_response(200)
          self.send_header("Content-type", "text/html")
          self.end_headers()
          self.wfile.write(f"{welcome_message}. Secret Password: {secret_password}".encode())

  def run(server_class=HTTPServer, handler_class=MyHandler):
      server_address = ('', 8000)
      httpd = server_class(server_address, handler_class)
      print("Starting httpd server on port 8000...")
      httpd.serve_forever()

  if __name__ == "__main__":
      run()
