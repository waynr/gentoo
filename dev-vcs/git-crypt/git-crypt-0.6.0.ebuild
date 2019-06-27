# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="transparent file encryption in git"
HOMEPAGE="https://www.agwa.name/projects/git-crypt/"
SRC_URI="https://github.com/AGWA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p "${D}/${EPREFIX}"/usr/bin
	emake PREFIX="${D}/${EPREFIX}"/usr install
}
