# vim: ft=perl
# PDF viewer
$pdf_previewer = 'start mupdf %O %S';
$pdf_update_method = 2;

# Notifications
$compiling_cmd='notify-send -t 1000 -u low -a latexmk compiling "%T => %D"';
$failure_cmd='notify-send -t 1000 -u critical -a latexmk failure "%T => %D"';
$success_cmd='notify-send -t 1000 -a latexmk success "%T => %D"';
