﻿# language: ru
# encoding: utf-8
#parent uf:
@UF9_Вспомогательные_фичи
#parent ua:
@UA30_Прочие_макеты
#language: ru
@tree

@IgnoreOnCIMainBuild

Функциональность: ПроверкаПопыткиИсключения3 



Сценарий: ПроверкаПопыткиИсключения3
	И Я запоминаю значение выражения '1+1' в переменную "ИмяПеременной"
	
	Попытка
		И Я запоминаю значение выражения '2+2' в переменную "ИмяПеременной"
	Исключение	
		И Я запоминаю значение выражения '3+3' в переменную "ИмяПеременной"
		
	И я вывожу значение переменной "ИмяПеременной"
	
