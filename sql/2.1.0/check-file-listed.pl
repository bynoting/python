#####################################################################
#描述: 检查是否所有的SQL文件都被数据库升级脚本所包括,以避免缺漏
#作者: zhangtao, zhangtao.it@gmail.com, 200705
#####################################################################

@sqls = glob("*.sql");

while ($file= pop(@sqls)) {
    open FILE,"dbpatch.vbs" or die "Can't open : $!";
    my @list = grep /$file/, <FILE>;
    if (@list == 0){
	print "not include: $file \n";
    }
}

print "checking done."

