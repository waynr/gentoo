# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Mock library for boto"
HOMEPAGE="https://github.com/spulec/moto"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/aws-xray-sdk-python[${PYTHON_USEDEP}]
	dev-python/backports-tempfile[${PYTHON_USEDEP}]
	dev-python/cfn-python-lint[${PYTHON_USEDEP}]
	dev-python/cookies[${PYTHON_USEDEP}]
	dev-python/dicttoxml[${PYTHON_USEDEP}]
	>=dev-python/docker-py-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	dev-python/jsondiff[${PYTHON_USEDEP}]
	>=dev-python/boto-2.36.0[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.6.16[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.12.13[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pretty-yaml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/responses[${PYTHON_USEDEP}]
			>=dev-python/sure-1.4.11[${PYTHON_USEDEP}]
		  )
"

python_prepare_all() {
	# Disable tests that fail with network-sandbox.
	sed -e 's|^\(def \)\(test_context_manager()\)|\1_\2|' \
		-e 's|^\(def \)\(test_decorator_start_and_stop()\)|\1_\2|' \
		-i tests/test_core/test_decorator_calls.py || die

	# Disable tests that fail with userpriv.
	sed -e 's|^\(def \)\(test_invoke_function_from_sns()\)|\1_\2|' \
		-e 's|^\(def \)\(test_invoke_requestresponse_function()\)|\1_\2|' \
		-i tests/test_awslambda/test_lambda.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=${BUILDDIR}/lib \
		nosetests -sv ./tests || die
}
