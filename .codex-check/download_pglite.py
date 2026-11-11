import urllib.request,json,tarfile
from pathlib import Path
root=Path(__file__).resolve().parent
meta=json.load(urllib.request.urlopen('https://registry.npmjs.org/@electric-sql/pglite/latest',timeout=30))
file=root/'pglite.tgz'
urllib.request.urlretrieve(meta['dist']['tarball'],file)
with tarfile.open(file) as archive:
    archive.extractall(root/'pglite',filter='data')
print('PGlite',meta['version'])
