#!/bin/bash

# Mảng lưu trữ các tùy chọn đã chọn
declare -a selected_options

# Hàm hiển thị menu
show_menu() {
    echo "Chọn các tùy chọn cài đặt (có thể chọn nhiều, cách nhau bởi dấu cách):"
    echo "1) Cài đặt Neovim"
    echo "2) Cài đặt Nova Profile cho Terminal"
    echo "3) Cài đặt môi trường DevOps"
    echo "4) Cài đặt tất cả"
    echo "5) Thực thi các tùy chọn đã chọn"
    echo "6) Thoát"
}

# Hàm cài đặt Neovim
install_neovim() {
    echo "Đang cài đặt Neovim..."
    bash ./neovim/require.sh
}

# Hàm cài đặt Nova Profile
install_nova_profile() {
    echo "Đang cài đặt Nova Profile cho Terminal..."
    bash ./Nova_Profile/novaprofile.sh
}

# Hàm cài đặt môi trường DevOps
install_devops() {
    echo "Đang cài đặt môi trường DevOps..."
    bash ./OS/setup_devops.sh
}

# Hàm thực thi các tùy chọn đã chọn
execute_selected_options() {
    for option in "${selected_options[@]}"; do
        case $option in
        1) install_neovim ;;
        2) install_nova_profile ;;
        3) install_devops ;;
        esac
    done
    selected_options=() # Xóa các tùy chọn đã chọn sau khi thực thi
    echo "Đã thực thi tất cả các tùy chọn đã chọn."
}

# Main script
while true; do
    show_menu
    read -p "Nhập lựa chọn của bạn: " choices

    for choice in $choices; do
        case $choice in
        1 | 2 | 3)
            if [[ ! " ${selected_options[@]} " =~ " ${choice} " ]]; then
                selected_options+=("$choice")
                echo "Đã thêm tùy chọn $choice vào danh sách."
            else
                echo "Tùy chọn $choice đã được chọn trước đó."
            fi
            ;;
        4)
            selected_options=(1 2 3)
            echo "Đã chọn tất cả các tùy chọn."
            ;;
        5)
            if [ ${#selected_options[@]} -eq 0 ]; then
                echo "Chưa có tùy chọn nào được chọn."
            else
                execute_selected_options
            fi
            ;;
        6)
            echo "Thoát khỏi chương trình."
            exit 0
            ;;
        *)
            echo "Lựa chọn không hợp lệ: $choice. Vui lòng chọn lại."
            ;;
        esac
    done

    echo
    echo "Các tùy chọn hiện tại: ${selected_options[*]}"
    read -p "Nhấn Enter để tiếp tục..."
    clear
done
