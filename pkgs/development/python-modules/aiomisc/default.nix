{ lib
, aiocontextvars
  #, aiocarbon
, aiohttp
  #, aiohttp-asgi
, async-timeout
, buildPythonPackage
, colorlog
, croniter
, fastapi
, fetchPypi
, logging-journald
, poetry-core
, pytestCheckHook
, pythonOlder
, raven
  #, raven-aiohttp
, setproctitle
, setuptools
, uvloop
}:

buildPythonPackage rec {
  pname = "aiomisc";
  version = "17.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SJyCxKncHRdWZUdsosOCLLRYG+ym8utXwAJjn3BRRHU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorlog
    logging-journald
    setuptools
  ];

  nativeCheckInputs = [
    aiocontextvars
    async-timeout
    fastapi
    pytestCheckHook
    raven
    setproctitle
  ]  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    #asgi = [
    #  aiohttp-asgi
    #];
    cron = [
      croniter
    ];
    #carbon = [
    #  aiocarbon
    #];
    #raven = [
    #  raven-aiohttp
    #];
    uvloop = [
      uvloop
    ];
  };

  pythonImportsCheck = [
    "aiomisc"
  ];

  # Upstream stopped tagging with 16.2
  doCheck = false;

  # disabledTestPaths = [
  #   # Dependencies are not available at the moment
  #   "tests/test_entrypoint.py"
  #   "tests/test_raven_service.py"
  # ];

  meta = with lib; {
    description = "Miscellaneous utils for asyncio";
    homepage = "https://github.com/aiokitchen/aiomisc";
    changelog = "https://github.com/aiokitchen/aiomisc/blob/master/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
