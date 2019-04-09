#!/bin/bash
pushd testserver/
python3 -m http.server 8000
popd