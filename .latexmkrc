# vim: ft=perl
# PDF viewer
$pdf_previewer = 'start mupdf %O %S';
$pdf_update_method = 2;

# Notifications
$compiling_cmd='notify-send -u low -a latexmk compiling "%T => %D"';
$failure_cmd='notify-send -u critical -a latexmk failure "%T => %D"';
$success_cmd='notify-send -a latexmk success "%T => %D"';
