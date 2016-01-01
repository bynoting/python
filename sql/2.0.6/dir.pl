###################################################################
# 描述: 列出所有的SQL文件并生成列表
# 应用: 主要用于生成数据库维护脚本时,自动产生部分脚本
#       如: dir.pl sql > db.vbs
# 作者: zhangtao,200704
###################################################################
# search for a file in all subdirectories
if ($#ARGV != 0) {
    print "usage: findfile filename\n";
    exit;
}

$filename = $ARGV[0];

# look in current directory
$dir = `pwd`;
chop($dir);

&searchDirectory($dir);

sub searchDirectory {
    local($dir);
    local(@lines);
    local($line);
    local($file);
    local($subdir);

    $dir = $_[0];

    # search this directory
    @lines = `ls -l | grep $filename`;
    foreach $line (@lines) {
	print $line
	$line =~ /\s+(\S+)$/;
	$file = $1;
	print "ExecuteSql \"$file\",\"$file\"\n";
    }
}
