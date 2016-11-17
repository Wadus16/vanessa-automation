﻿# encoding: utf-8
# language: ru

#https://github.com/silverbulleters/vanessa-behavior/issues/416

@IgnoreOn82Builds
@IgnoreOnOFBuilds

@tree

Функционал: Проверка работы остановки выполения шагов если установлен флаг ОстановкаПриВозникновенииОшибки
	Как Разработчик
	Я Хочу чтобы чтобы у меня была возможность остановить выполнение шагов если возникла ошибка в сценарии и установлен флаг ОстановкаПриВозникновенииОшибки
	Чтобы я мог использовать быстрее искать ошибки в сценариях
 


		
Сценарий: Проверка работы флага ОстановкаПриВозникновенииОшибки
		Когда Я открываю VanessaBehavior в режиме TestClient	

		И В поле с именем "КаталогФичСлужебный" я указываю путь к служебной фиче "ПроверкаРаботыФлагаОстановкаПриВозникновенииОшибки"
		И В открытой форме я перехожу к закладке с заголовком "Библиотеки"
		И В открытой форме я нажимаю на кнопку с именем "КаталогиБиблиотекДобавить"
		И я добавляю в библиотеки строку с стандартной библиотекой "Libraries"
		И     я изменяю флаг "Остановка при возникновении ошибки"			
		И в VanessaBehavoir в TestClient я загружаю и выполняю сценарии
				И В открытой форме я нажимаю на кнопку "Перезагрузить сценарии"
				И Я делаю паузу 6 секунды		
				
				И В открытой форме я нажимаю на кнопку с заголовком "Выполнить сценарии"
				И Я делаю паузу 6 секунды		

				
		Тогда в VanessaBehavoir в TestClient снипет заполнился верно
			И     таблица формы с именем "ДеревоТестов" стала равной:
				| 'Статус'  |
				| ''        |
				| ''        |
				| 'Failed'  |
				| 'Success' |
				| 'Failed'  |
				| ''        |
				| ''        |
					