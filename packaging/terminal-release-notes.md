Ngó Sen Terminal là bản **không chính thức** dựa trên [Ngó Sen](https://github.com/ngosen/ngosen), sửa lỗi gõ
tiếng Việt trong terminal của VS Code, kể cả khi chạy trên GNOME Wayland. Thay đổi của bản này nằm ở
[packaging/debian/changelog](https://github.com/nguyenduchoan/ngosen-terminal/blob/main/packaging/debian/changelog).

Cài hoặc cập nhật trên Debian, Ubuntu (amd64, arm64):

```
curl -fsSL https://raw.githubusercontent.com/nguyenduchoan/ngosen-terminal/main/install.sh | bash
```

Hoặc tải gói đúng bản phân phối bên dưới (tên tệp có `bookworm`, `trixie`, `forky`, `jammy`, `noble`,
`resolute`, `stonking`), đối chiếu với `SHA256SUMS`, rồi cài bằng `sudo apt install ./<tên-tệp>.deb` và
chạy `fcitx5 -rd`.

| Bản phân phối | Tên mã |
|---|---|
| Debian 12 | `bookworm` |
| Debian 13 | `trixie` |
| Debian testing, Kali Rolling | `forky` |
| Ubuntu 22.04 | `jammy` |
| Ubuntu 24.04 | `noble` |
| Ubuntu 26.04 | `resolute` |
| Ubuntu 26.10 | `stonking` |
