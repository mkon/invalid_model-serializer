# 0.1 -> 0.2

Some changes to make writing serializers for non-active record objects easier.

* ErrorSerializer class was renamed to EachSerializer
* EachSerializer's initializer now accepts 3 parameters instead of 2. The first
parameter is now the resource
* The included error model was removed
