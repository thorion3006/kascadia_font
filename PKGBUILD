# Maintainer: Sajeev Ramasamy <thorion3006@gmail.com>
pkgname=(ttf-kascadia)
pkgbase=cascadia-font
pkgver=2106.17
pkgrel=1
pkgdesc='Cascadia Powerline fonts patched with missing glyphs from nerd font.'
arch=(any)
url="https://github.com/thorion3006/kascadia_font"
license=(OFL)
source=("$url/releases/download/$pkgver/Kascadia-$pkgver.zip")
md5sums=('SKIP')

package() {
        cd "${Kascadia-$pkgver}"
        install -Dm644 -t "$pkgdir/usr/share/fonts/commissioner" *.ttf
}

