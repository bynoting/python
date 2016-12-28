__author__ = 'lq'
#coding=utf-8
class Fruit(object):
    version = 1.0  #静态对象
    """docstring for Fruit"""
    def __init__(self):
        super(Fruit, self).__init__()
        self.color = 'blue'

    def is_clean(cls):
        print cls.color
        return True

    @classmethod
    def foo(cls):
        #类方法可以被对象调用，也可以被实例调用；传入的都是类对象，主要用于工厂方法，具体的实现就交给子类处理
        Fruit.version += 1
        print cls.color
        print 'calling this method foo()'

    @staticmethod
    def pish_color(color):
        #静态方法参数没有实例参数 self, 也就不能调用实例参数
        Fruit.color = color

    def add_foo(self):
        Fruit.version += 1



if __name__ == "__main__":
    o = Fruit()
    o.is_clean()
    # o.pish_color('Green')
    # o.foo()
    Fruit.foo()
    # o.add_foo()
    # print o.version
    # o.foo()
    # print o.version
    # print Fruit.version