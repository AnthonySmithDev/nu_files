import os
import json
from urllib.parse import urlparse, unquote

from mitmproxy import ctx


class Saver:
    def __init__(self):
        self.base_directory = "sites"

    def load(self, loader):
        os.makedirs(self.base_directory, exist_ok=True)

    def response(self, flow):
        url = flow.request.pretty_url
        decoded_url = unquote(url)
        parse = urlparse(decoded_url)
        domain = parse.netloc
        path = parse.path
        query = parse.query

        dirs = path.split("/")
        file_name = dirs.pop()

        source_path = os.path.join(self.base_directory, domain, *dirs)
        os.makedirs(source_path, exist_ok=True)

        file_path = source_path + "/" + file_name

        if query != "":
            file_path = file_path + "?" + query

        extension = ""
        header = flow.response.headers.get("content-type", "")
        if header != "":
            contentType = header.split(";")[0]
            extension = contentType.split("/")[1]

        if extension == "json":
            with open(file_path + "." + extension, "w") as file:
                data_str = flow.response.content.decode()
                data_json = json.loads(data_str)
                json.dump(data_json, file, indent=4)
        else:
            with open(file_path + "." + extension, "wb") as file:
                file.write(flow.response.content)

        ctx.log.info(f"Archivo guardado: {file_path}")


addons = [Saver()]
