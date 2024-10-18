#!/bin/bash

# Hàm kiểm tra lỗi
check_error() {
  if [ $? -ne 0 ]; then
    echo "Lỗi: $1"
    exit 1
  fi
}

# Kiểm tra và cài đặt các công cụ cần thiết
install_dependencies() {
  echo "Kiểm tra và cài đặt các công cụ cần thiết..."
  sudo apt update
  sudo apt install -y wget unzip
  check_error "Không thể cài đặt các công cụ cần thiết"
}

# Cài đặt JetBrains Mono Nerd Font
install_font() {
  echo "Đang cài đặt JetBrains Mono Nerd Font..."

  # Tạo thư mục fonts nếu chưa tồn tại
  mkdir -p ~/.local/share/fonts

  # Tải và giải nén font
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
  check_error "Không thể tải font"

  unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
  check_error "Không thể giải nén font"

  # Xóa file zip
  rm JetBrainsMono.zip

  # Cập nhật cache font
  fc-cache -f -v
  check_error "Không thể cập nhật cache font"

  echo "JetBrains Mono Nerd Font đã được cài đặt thành công."
}

# Kiểm tra xem file terminal_profile.dconf có tồn tại không
if [ ! -f "nova.dconf" ]; then
  echo "Lỗi: File nova.dconf không tồn tại trong thư mục hiện tại."
  exit 1
fi

# Cài đặt các dependencies và font
install_dependencies
install_font

# Lấy UUID của profile mặc định
DEFAULT_PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
if [ -z "$DEFAULT_PROFILE" ]; then
  echo "Không thể lấy UUID của profile mặc định"
  exit 1
fi

# Áp dụng cấu hình
echo "Đang áp dụng cấu hình..."
dconf load /org/gnome/terminal/legacy/profiles:/:$DEFAULT_PROFILE/ <nova.dconf
check_error "Không thể áp dụng cấu hình"

echo "Cài đặt hoàn tất! Vui lòng khởi động lại terminal để áp dụng các thay đổi."
