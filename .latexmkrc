# vim: ft=perl
# PDF viewer
$pdf_previewer = 'start mupdf %O %S';
$pdf_update_method = 2;

# Notifications
my $notify_id=-1;
$compiling_cmd='internal notif_comp';
$failure_cmd='internal notif_fail';
$success_cmd='internal notif_succ';

sub notif_comp {
    $notify_id=`notify-send -c $notify_id -u low -a latexmk compiling 2>/dev/null`;
    chomp($notify_id);
}

sub notif_fail {
    $notify_id=`notify-send -c $notify_id -u critical -a latexmk failure 2>/dev/null`;
    chomp($notify_id);
}

sub notif_succ {
    $notify_id=`notify-send -c $notify_id -a latexmk success 2>/dev/null`;
    chomp($notify_id);
}
