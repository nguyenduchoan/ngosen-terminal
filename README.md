# Ngó Sen Terminal

Bộ gõ tiếng Việt cho Linux (chạy trên [fcitx5](https://github.com/fcitx/fcitx5)): mỗi phím gõ đi thẳng vào ứng
dụng, không bị giữ lại ở bộ gõ. Bản này sửa thêm cho terminal (cửa sổ dòng lệnh) của VS Code: Tab hoàn thành
lệnh đúng thứ tự, terminal mới không nhận nhầm phím của terminal cũ, và không mất chữ có dấu trên GNOME Wayland.

> **Đây là bản không chính thức (unofficial) dựa trên [Ngó Sen](https://github.com/ngosen/ngosen).**
> Nhóm Ngó Sen không phát hành, không bảo trợ bản này. Lỗi của bản này xin báo ở
> [Issues của repo này](https://github.com/nguyenduchoan/ngosen-terminal/issues), đừng báo cho Ngó Sen.

## Nguồn gốc: repo này dựa trên đâu

Mã nguồn là **bản tách nhánh (fork) của Ngó Sen**. Repo giữ nguyên toàn bộ lịch sử commit của Ngó Sen; các
thay đổi của Ngó Sen Terminal là những commit nằm sau commit gốc dưới đây (`git log 7cb39e4..main`).

| Mục | Giá trị |
|---|---|
| Repo gốc | [github.com/ngosen/ngosen](https://github.com/ngosen/ngosen) |
| Phiên bản gốc | Ngó Sen 1.5.5-1, tag [`ngosen-1.5.5-1`](https://github.com/ngosen/ngosen/releases/tag/ngosen-1.5.5-1) |
| Commit gốc | [`7cb39e4c3210f5b64369f8bdf14815c8a913c100`](https://github.com/ngosen/ngosen/commit/7cb39e4c3210f5b64369f8bdf14815c8a913c100) (21/10/2026) |
| Lõi gõ bản Go (dùng cho Debian 12) | kho con (submodule) `bamboo/bamboo-core` từ [LotusInputMethod/bamboo-core](https://github.com/LotusInputMethod/bamboo-core), commit `e896341` |
| Lõi gõ bản Rust (các bản phân phối khác) | thư mục `bamboo-rs/`, từ [bamboo-vi/bamboo-core](https://github.com/bamboo-vi/bamboo-core) |
| Giấy phép | GPL-3.0-or-later, giống Ngó Sen |

Ngó Sen lại được phát triển từ [fcitx5-lotus](https://github.com/LotusInputMethod/fcitx5-lotus) và
[VMK](https://github.com/thanhpy2009/VMK). Lõi biến `tieengs` thành `tiếng` là bamboo-core (giấy phép MIT), bản
Go của [@t1ld3x](https://github.com/t1ld3x) ([BambooEngine/bamboo-core](https://github.com/BambooEngine/bamboo-core))
và bản Rust của [@nguyen10t2](https://github.com/nguyen10t2).

```
fcitx5-lotus, VMK ──► Ngó Sen 1.5.5-1 (ngosen/ngosen @ 7cb39e4) ──► Ngó Sen Terminal (repo này)
```

README gốc của Ngó Sen được giữ nguyên ở [README.ngosen.md](README.ngosen.md). Tác giả và giấy phép của từng
phần nằm trong [packaging/debian/copyright](packaging/debian/copyright).

## Khác gì so với Ngó Sen

Các bản sửa chỉ có tác dụng ở chế độ **Gõ Sen**, chế độ mặc định của Ngó Sen. Ngày sửa: 23/10/2026.

| Thay đổi | Lý do |
|---|---|
| VS Code nhận chữ qua Fcitx (D-Bus hoặc Fcitx4): phần chữ thay dấu được gửi **từng ký tự** | Chromium (nhân trình duyệt của VS Code) có thể xếp một lần chèn nhiều ký tự ra sau phím kế tiếp trong terminal, ví dụ Tab, làm chữ đến sai thứ tự (`sour` + Tab thành `source/sour`) |
| VS Code đặt lại ngữ cảnh nhập (input context) mà không báo văn bản quanh con trỏ: **xoá từ đang gõ** | VS Code dùng chung một ngữ cảnh nhập cho nhiều terminal, nên terminal mới có thể nhận phím của terminal trước (`d` ở terminal cũ cộng `d` ở terminal mới thành `đ`) |
| Chữ đi qua IBus: **vẫn gửi cả cụm trong một lần** như Ngó Sen gốc, nay có kiểm thử giữ nguyên | GNOME Wayland chỉ giữ lần chèn cuối cùng; một bản thử tách ký tự cả trên IBus đã làm mất chữ có dấu (`maats` thành `mt` thay vì `mất`) |

Mã thay đổi:

- `src/ngosen-fcitx-host.cpp`: gửi từng ký tự cho VS Code qua Fcitx, giữ nguyên cụm qua IBus.
- `src/ngosen-engine.cpp`: xoá từ đang gõ khi VS Code đặt lại ngữ cảnh nhập.
- `test/terminal-reset-commit.cpp`: bài kiểm thử hồi quy (kiểm thử chặn lỗi cũ quay lại) cho cả ba điểm trên.
- Đóng gói: số phiên bản `1:1.5.5-1+terminal1`, `install.sh` tải gói từ repo này, nút báo lỗi trong cửa sổ
  cài đặt trỏ về repo này, bỏ các workflow phát hành cần khoá ký của Ngó Sen.

## Cài

Hỗ trợ Debian và Ubuntu, máy amd64 (x86_64) và arm64:

| Bản phân phối | Tên mã |
|---|---|
| Debian 12 | `bookworm` |
| Debian 13 | `trixie` |
| Debian testing, Kali Rolling | `forky` |
| Ubuntu 22.04 | `jammy` |
| Ubuntu 24.04 | `noble` |
| Ubuntu 26.04 | `resolute` |
| Ubuntu 26.10 | `stonking` |

Linux Mint, Pop!_OS và các bản dựa trên Ubuntu/Debian dùng gói theo tên mã Ubuntu/Debian gốc. Fedora, Arch,
openSUSE chưa có gói của bản này; dùng [Ngó Sen gốc](https://github.com/ngosen/ngosen) hoặc tự dựng từ mã.

### Lệnh một dòng

```
curl -fsSL https://raw.githubusercontent.com/nguyenduchoan/ngosen-terminal/main/install.sh | bash
```

Lệnh tải gói đúng bản phân phối từ [bản phát hành mới nhất](https://github.com/nguyenduchoan/ngosen-terminal/releases/latest),
so mã băm SHA-256 (mã kiểm tra tệp tải về không bị sửa) và hỏi lại trước khi cài. Sau đó nó thiết lập desktop
cho tài khoản đang chạy lệnh, giống Ngó Sen gốc:

- GNOME (desktop mặc định của Ubuntu): đặt fcitx5 thay IBus, bật extension sửa lỗi gõ khi cần.
- KDE Plasma Wayland: chọn fcitx5 làm bàn phím ảo (Virtual Keyboard).
- Xfce, Cinnamon, MATE: đặt fcitx5 làm bộ gõ bằng im-config.

Cài xong, đăng xuất rồi đăng nhập lại. Bấm **Ctrl+Space** để bật/tắt tiếng Việt.

Thêm `-s -- --no-setup` sau `bash` nếu muốn tự thiết lập desktop.

### Cài gói `.deb` bằng tay

1. Tải gói có tên mã bản phân phối của bạn ở trang [Releases](https://github.com/nguyenduchoan/ngosen-terminal/releases),
   ví dụ `fcitx5-ngosen_1.5.5-1+terminal1_noble_amd64.deb` cho Ubuntu 24.04. Xem tên mã bằng
   `. /etc/os-release; echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}`.
2. Kiểm tra mã băm với tệp `SHA256SUMS` cùng trang: `sha256sum -c --ignore-missing SHA256SUMS`.
3. Cài và khởi động lại fcitx5:

   ```
   sudo apt install ./fcitx5-ngosen_1.5.5-1+terminal1_noble_amd64.deb
   fcitx5 -rd
   ```

4. Mở "Fcitx5 Configuration", thêm bộ gõ **Ngó Sen** nếu chưa có.

### Tự dựng từ mã (build from source)

```
sudo apt install git dpkg-dev
git clone --recurse-submodules https://github.com/nguyenduchoan/ngosen-terminal.git
cd ngosen-terminal
cp -r packaging/debian debian
```

Debian 12 dùng lõi Go:

```
sudo apt build-dep ./
dpkg-buildpackage --build=binary --no-sign
```

Các bản khác dùng lõi Rust, giống gói phát hành:

```
sudo apt build-dep -o APT::Build-Profiles=pkg.ngosen.rust ./
dpkg-buildpackage --build=binary --no-sign --build-profiles=pkg.ngosen.rust
```

Lệnh dựng chạy toàn bộ kiểm thử CTest (bộ kiểm thử tự động) và tạo gói ở thư mục cha. Cài bằng
`sudo apt install ../fcitx5-ngosen_*.deb` (bỏ qua gói `-dbgsym`), rồi chạy `fcitx5 -rd`. Cách dựng bằng CMake
cho bản phân phối khác nằm ở [TU-DUNG.md](TU-DUNG.md) của Ngó Sen (đổi đường dẫn clone thành repo này).

### Đang dùng Ngó Sen gốc

Hai bản dùng chung tên gói `fcitx5-ngosen` và chung cấu hình trong `~/.config/fcitx5/conf/ngosen*.conf`.
Phiên bản `1:1.5.5-1+terminal1` cao hơn `1:1.5.5-1` của Ngó Sen nên apt cài đè lên bình thường.

Nếu máy đã thêm kho APT của Ngó Sen, khi Ngó Sen ra bản mới hơn (ví dụ 1.5.6), `apt upgrade` sẽ thay bằng bản
gốc và mất các bản sửa ở trên. Muốn giữ Ngó Sen Terminal thì xoá `/etc/apt/sources.list.d/ngosen.list`, hoặc
giữ nguyên gói bằng `sudo apt-mark hold fcitx5-ngosen`.

## Dùng

- **Ctrl+Space**: bật/tắt tiếng Việt.
- Mở "Ngó Sen Settings" trong menu ứng dụng, trang Gõ chữ, để đổi kiểu gõ (Telex, VNI…). Giữ chế độ gõ là
  **Gõ Sen** để có các bản sửa trên.

Thử nhanh trong terminal VS Code, ở thư mục có thư mục con `source`:

| Gõ | Phải ra |
|---|---|
| `cd sour` rồi Tab | `cd source/` |
| `chuwx maats` rồi Space | `chữ mất ` |
| `Tooi ddang gox tieengs Vieetj` | `Tôi đang gõ tiếng Việt` |

## Đã kiểm thử những gì

- **Kiểm thử tự động:** mọi gói phát hành đều được dựng và chạy toàn bộ CTest trên từng bản phân phối, gồm bài
  `terminal_reset_commit` mới. Bài này thất bại trên mã Ngó Sen gốc và đạt trên mã đã sửa. Dựng thử trong
  Docker cho Debian 12 (lõi Go) và Ubuntu 24.04 (lõi Rust): tất cả kiểm thử đạt.
- **Gõ thật trên Debian 12, GNOME 43 Wayland, VS Code chạy Wayland gốc**, máy tự gõ với nhịp 120 ms/phím.
  Kết quả đọc trực tiếp từ chữ terminal nhận được (qua PTY, kênh ký tự của terminal), không chỉ nhìn màn hình:

  | Ca đo | Bản thử tách ký tự cả trên IBus | Ngó Sen Terminal |
  |---|---|---|
  | `maats` | `mt` | `mất` |
  | `maats` rồi Space | không đo (ca trên đã lỗi) | `mất ` |
  | `chuwx maats` rồi Space | không đo | `chữ mất ` |
  | `cd sour` + Tab, gõ tiếp `new` | không đo | `cd source/`, rồi `cd source/new` |

  Chưa có lần đo giao diện đối chứng với Ngó Sen 1.5.5-1 chưa sửa. Bài gõ câu dài trên Wayland bị dừng giữa
  chừng vì cửa sổ thử mất quyền nhận bàn phím, nên chưa tính là đạt.

### Giới hạn đã biết

- Cách gửi từng ký tự chỉ áp dụng cho ứng dụng có tên chương trình `code` (VS Code) và `codex-web-gpt-linux`.
  VSCodium, Code - OSS, Cursor và các ứng dụng Electron khác **chưa được nhận diện và chưa kiểm thử**.
- Máy tự gõ cực nhanh (nhịp 30 ms/phím trở xuống) vẫn có thể sai thứ tự trong Electron. Các lần đo trước
  trên Debian 12 đạt ở nhịp 80 và 120 ms/phím.
- Chưa đo đầy đủ GTK4, Qt6, LibreOffice, Vim toàn màn hình. Ngó Sen gốc vẫn xử lý các ứng dụng này như cũ.
- Chỉ phát hành gói Debian/Ubuntu.

## Gỡ

```
curl -fsSL https://raw.githubusercontent.com/nguyenduchoan/ngosen-terminal/main/install.sh | bash -s -- --uninstall
```

Hoặc gỡ bằng tay: bỏ Ngó Sen khỏi danh sách bộ gõ trong "Fcitx5 Configuration", rồi chạy
`sudo apt remove fcitx5-ngosen` và `fcitx5 -rd`. Cấu hình `~/.config/fcitx5/conf/ngosen*.conf` được giữ lại.
Muốn quay về Ngó Sen gốc thì cài lại theo [README.ngosen.md](README.ngosen.md).

## Cho người bảo trì

### Phát hành bản mới

1. Thêm mục mới ở đầu `packaging/debian/changelog`, số phiên bản dạng `1:<bản Ngó Sen>+terminal<N>`.
2. Commit lên `main`, gắn tag theo dạng `v<bản Ngó Sen không có -1>-terminal<N>` rồi đẩy tag:

   ```
   git tag v1.5.5-terminal1
   git push origin v1.5.5-terminal1
   ```

3. Workflow [Build & Release](.github/workflows/terminal-release.yml) kiểm tra tag khớp changelog, dựng 14 gói
   (7 bản phân phối × amd64/arm64), chạy kiểm thử, rồi tạo bản phát hành kèm `SHA256SUMS`. `install.sh` luôn
   lấy bản phát hành mới nhất.

Không đẩy các tag `ngosen-*` của Ngó Sen lên repo này (đừng dùng `git push --tags`).

### Cập nhật theo Ngó Sen

Remote `upstream` trỏ về Ngó Sen:

```
git remote add upstream https://github.com/ngosen/ngosen.git   # nếu chưa có
git fetch upstream --tags
git merge ngosen-1.5.6-1          # tag phát hành mới của Ngó Sen
```

Sau khi gộp: giải quyết xung đột, chạy lại toàn bộ kiểm thử, thêm mục changelog `1:1.5.6-1+terminal1`, cập
nhật bảng nguồn gốc ở đầu README này, rồi phát hành như trên.

### Đóng góp ngược về Ngó Sen

Các bản sửa ở đây không phụ thuộc Debian 12 và có bài kiểm thử riêng, có thể gửi thành pull request cho
[ngosen/ngosen](https://github.com/ngosen/ngosen). Khi Ngó Sen nhận các bản sửa này, người dùng có thể quay
lại dùng bản gốc.

## Giấy phép và ghi công

GPL-3.0-or-later, xem [LICENSE](LICENSE). Bản quyền phần lớn mã thuộc các tác giả Ngó Sen, fcitx5-lotus,
VMK, bamboo-core và fcitx5 (CSSlayer); danh sách đầy đủ ở [packaging/debian/copyright](packaging/debian/copyright).
Theo yêu cầu của Ngó Sen, mọi bản sao hay bản sửa từ mã này phải giữ giấy phép GPL-3.0-or-later và ghi nguồn
kèm link tới [ngosen/ngosen](https://github.com/ngosen/ngosen).

Tên "Ngó Sen" thuộc dự án Ngó Sen; tên Ngó Sen Terminal chỉ nhằm cho biết nguồn gốc của bản này.

## English

Ngó Sen Terminal is an unofficial fork of [Ngó Sen](https://github.com/ngosen/ngosen), a Vietnamese input method
for fcitx5, based on Ngó Sen 1.5.5-1 (commit `7cb39e4`). In Sen mode it sends replacement text to VS Code one
character at a time over the Fcitx frontends, so terminal Tab completion stays in order; clears the word when
VS Code resets a shared terminal context; and keeps IBus commits whole, which GNOME Wayland needs. A regression
test covers all three. Debian and Ubuntu packages are published in this repository's releases; install
with the one-line command above. Licensed GPL-3.0-or-later. Please report bugs here, not to Ngó Sen.
