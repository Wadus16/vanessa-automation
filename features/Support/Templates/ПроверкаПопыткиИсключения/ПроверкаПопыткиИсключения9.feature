﻿# language: ru
# encoding: utf-8
#parent uf:
@UF9_Вспомогательные_фичи
#parent ua:
@UA30_Прочие_макеты
#language: ru
@tree

@IgnoreOnCIMainBuild

Функциональность: ПроверкаПопыткиИсключения9 



Сценарий: ПроверкаПопыткиИсключения9_1
	И Я запоминаю значение выражения '0+0' в переменную "ИмяПеременной"
	
	Попытка
		Попытка
			И Я запоминаю значение выражения '1+1' в переменную "ИмяПеременной"
			И Я запоминаю значение выражения '11+11' в переменную "ИмяПеременной"
			И я вызываю исключение "ТекстИсключения1"
		Исключение		
			И Я запоминаю значение выражения '3+3' в переменную "ИмяПеременной"
			И Я запоминаю значение выражения '33+33' в переменную "ИмяПеременной"
			И я вызываю исключение "ТекстИсключения2"
			И Я запоминаю значение выражения '333+333' в переменную "ИмяПеременной"
	Исключение	


Сценарий: ПроверкаПопыткиИсключения9_2
	И Я запоминаю значение выражения '0+0' в переменную "ИмяПеременной"
	
	Попытка
		Попытка
			И Я запоминаю значение выражения '1+1' в переменную "ИмяПеременной"
			И Я запоминаю значение выражения '11+11' в переменную "ИмяПеременной"
			И я вызываю исключение "ТекстИсключения1"
		Исключение		
			И Я запоминаю значение выражения '3+3' в переменную "ИмяПеременной"
			И Я запоминаю значение выражения '33+33' в переменную "ИмяПеременной"
			И я вызываю исключение "ТекстИсключения2"
			И Я запоминаю значение выражения '333+333' в переменную "ИмяПеременной"
	Исключение	
