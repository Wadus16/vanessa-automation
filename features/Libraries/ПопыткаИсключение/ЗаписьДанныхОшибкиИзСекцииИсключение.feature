﻿# language: ru
# encoding: utf-8
#parent uf:
@UF8_Turbo_Gherkin
#parent ua:
@UA23_Использовать_условия_в_сценариях

@IgnoreOnOFBuilds
@IgnoreOn82Builds
@IgnoreOnWeb


@tree



Функциональность: Запись данных ошибки из секции исключение

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий





Сценарий: Запись данных ошибки из секции исключение
	* Подготовка теста
		Дано Я закрыл все окна клиентского приложения
		И я закрываю сеанс TESTCLIENT
		Когда я запускаю служебный сеанс TestClient с ключом TestManager в той же базе

		Когда Я открываю VanessaAutomation в режиме TestClient со стандартной библиотекой

		Когда В поле с именем "КаталогФичСлужебный" я указываю путь к служебной фиче "ПроверкаПопыткиИсключения/ПроверкаПопыткиИсключения13"
		И В открытой форме я перехожу к закладке с заголовком "Сервис"
		
		И я перехожу к закладке с именем "СтраницаОтчетыОЗапуске"
		И я разворачиваю группу с именем "ГруппаОтчеты"
		И я устанавливаю флаг с именем 'ДелатьОтчетВФорматеАллюр'
		И в поле с именем 'КаталогВыгрузкиAllure' я ввожу текст '$КаталогИнструментов$\tools\Allure'
		И я перехожу к следующему реквизиту
		И я запоминаю значение поля с именем "КаталогВыгрузкиAllure" как "КаталогAllure"
		И я создаю каталог "$КаталогAllure$"
		И я очищаю каталог "$КаталогAllure$"


		И я перехожу к закладке с именем "ГруппаjUnit"
		И я устанавливаю флаг с именем 'ДелатьОтчетВФорматеjUnit'
		И в поле каталог отчета jUnit я указываю путь к относительному каталогу "tools\jUnit"
		И я перехожу к следующему реквизиту
		И я запоминаю значение поля с именем "КаталогВыгрузкиJUnit" как "КаталогjUnit"


		И я устанавливаю флаг с именем 'ДелатьЛогОшибокВТекстовыйФайл'
		И в поле 'Имя каталога для лога ошибок' я ввожу текст 'C:\Temp\ЛогОшибокVA'
			
		И я перехожу к закладке с именем "СтраницаСкриншоты"
		И я устанавливаю флаг с именем 'ДелатьСкриншотПриВозникновенииОшибки'
		И я устанавливаю флаг с именем 'ИспользоватьКомпонентуVanessaExt1'
		И я устанавливаю флаг с именем 'ИспользоватьВнешнююКомпонентуДляСкриншотов'
		И в поле каталог скриншотов я указываю путь к относительному каталогу "tools\ScreenShotsTest"
			
		И я перехожу к закладке с именем "ГруппаСППР"
		И я устанавливаю флаг с именем 'ДелатьОтчетВФорматеСППР'
		И в поле с именем 'КаталогВыгрузкиСППР' я ввожу текст '$КаталогИнструментов$\tools\SPPR'
		И я очищаю каталог '$КаталогИнструментов$/tools/SPPR'
		
		И Я нажимаю на кнопку перезагрузить сценарии в Vanessa-Automation TestClient
		И Я нажимаю на кнопку выполнить сценарии в Vanessa-Automation TestClient
	
	* Проверка файлов json ошибок
		И Я запоминаю значение выражения '0' в переменную "КоличествоФайловJson"
		И для каждого файла "ТекущийФайл" из каталога "C:\Temp\ЛогОшибокVA"
			
			Если '$_Расширение$ = ".json"' Тогда
				И Я запоминаю значение выражения '$КоличествоФайловJson$ + 1' в переменную "КоличествоФайловJson"
				И я читаю json файл "$_ПолноеИмя$" в переменную "ДанныеJson"
				И выражение внутреннего языка '$ДанныеJson$.МассивСкриншотов.Количество()' имеет значение 1
				И выражение внутреннего языка '$ДанныеJson$.МассивФайлов.Количество()' имеет значение 3
				И файл "$_ПолноеИмя$" не содержит строки
					| '"ТекстОшибки": "",' |
				И я запоминаю содержимое файла "$_ПолноеИмя$" в переменную "ТекстФайла"
				Если 'Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 1") = 0 И Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 2") = 0' Тогда
					Тогда я вызываю исключение "В json файле нет нужно текста исключения."
				Если 'Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 1") > 0 И Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 2") > 0' Тогда
					Тогда я вызываю исключение "В json файле найдены оба текста исключения, а должен быть только один."
					
		Тогда переменная "КоличествоФайловJson" имеет значение 2
	

	* Проверка файлов Allure
		И в каталоге аллюр появился 1 файл json
		И я читаю json файл "$НайденноеИмяФайлаjson$" в переменную "ДанныеJson"
		//файлы, приложенные к первому шагу
		И выражение внутреннего языка '$ДанныеJson$.steps[3].steps[0].attachments.Количество()' имеет значение 4
		//файлы, приложенные ко второму шагу
		И выражение внутреннего языка '$ДанныеJson$.steps[5].steps[0].attachments.Количество()' имеет значение 4

		
	* Проверка файлов xml СППР
		И Я запоминаю значение выражения '0' в переменную "КоличествоФайловXML"
		И для каждого файла "ТекущийФайл" из каталога '$КаталогИнструментов$/tools/SPPR'
			
			Если '$_Расширение$ = ".xml"' Тогда
				И Я запоминаю значение выражения '$КоличествоФайловXML$ + 1' в переменную "КоличествоФайловXML"
				И я запоминаю содержимое файла "$_ПолноеИмя$" в переменную "ТекстФайла"
				Если 'Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 1") = 0 И Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 2") = 0' Тогда
					Тогда я вызываю исключение "В xml файле нет нужно текста исключения."
				Если 'Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 1") > 0 И Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 2") > 0' Тогда
					Тогда я вызываю исключение "В xml файле найдены оба текста исключения, а должен быть только один."
					
		Тогда переменная "КоличествоФайловXML" имеет значение 2


	* Проверка файлов jUnit
		//jUnit формируется по всем дереву, поэтому он формируется после окончания выполнения сценариев
		И Я запоминаю значение выражения '0' в переменную "КоличествоФайловXML"
		И для каждого файла "ТекущийФайл" из каталога '$КаталогjUnit$'
			
			Если '$_Расширение$ = ".xml"' Тогда
				И Я запоминаю значение выражения '$КоличествоФайловXML$ + 1' в переменную "КоличествоФайловXML"
				И я запоминаю содержимое файла "$_ПолноеИмя$" в переменную "ТекстФайла"
				Если 'Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 1") = 0 ИЛИ Найти($ТекстФайла$, "Не получилось сравнить таблицу с эталоном 2") = 0' Тогда
					Тогда я вызываю исключение "В xml файле нет нужно текста исключения."
					
		Тогда переменная "КоличествоФайловXML" имеет значение 1


	* Проверка дерева шагов
		И я нажимаю на кнопку с именем 'ФормаРазвернутьВсеСтрокиДереваСлужебный'
		Тогда таблица "ДеревоТестов" стала равной:
			| 'Наименование'                                                                              | 'Статус'  |
			| 'ПроверкаПопыткиИсключения13.feature'                                                       | ''        |
			| 'ПроверкаПопыткиИсключения13'                                                               | ''        |
			| 'ПроверкаПопыткиИсключения13'                                                               | 'Failed'  |
			| 'Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий'               | ''        |
			| 'Дано Я открыл новый сеанс TestClient или подключил уже существующий'                       | 'Success' |
			| 'И Я закрыл все окна клиентского приложения'                                                | 'Success' |
			| 'И В командном интерфейсе я выбираю \'Основная\' \'Справочник1\''                           | 'Success' |
			| 'Попытка'                                                                                   | ''        |
			| 'Тогда таблица "Список" стала равной:'                                                      | 'Success' |
			| '\| \'Наименование\'      \|'                                                               | ''        |
			| '\| \'ТакогоЭлементаНет\' \|'                                                               | ''        |
			| 'Исключение'                                                                                | 'Failed'  |
			| 'И я регистрирую ошибку по данным исключения "Не получилось сравнить таблицу с эталоном 1"' | 'Failed'  |
			| 'И Я запоминаю значение выражения \'1\' в переменную "ИмяПеременной"'                       | 'Success' |
			| 'Попытка'                                                                                   | ''        |
			| 'И я жду, что таблица "Список" станет равна данной в течение 3 секунд:'                     | 'Success' |
			| '\| \'Наименование\'      \|'                                                               | ''        |
			| '\| \'ТакогоЭлементаНет\' \|'                                                               | ''        |
			| 'Исключение'                                                                                | 'Failed'  |
			| 'И я регистрирую ошибку по данным исключения "Не получилось сравнить таблицу с эталоном 2"' | 'Failed'  |
			| 'И Я запоминаю значение выражения \'1\' в переменную "ИмяПеременной"'                       | 'Success' |
		
			

	* Закрытие клиента тестирования
		И я перехожу к закладке с именем "ГруппаСлужебная"
		И В поле с именем "КаталогФичСлужебный" я указываю путь к служебной фиче "ЗакрытьПодключенныйTestClient/ЗакрытьПодключенныйTestClient"
		
		И Я нажимаю на кнопку перезагрузить сценарии в Vanessa-Automation TestClient
		И Я нажимаю на кнопку выполнить сценарии в Vanessa-Automation TestClient


Сценарий: Активизация основного клиента
	И я закрываю TestClient "TM"
	И в таблице клиентов тестирования я активизирую строку 'Этот клиент'
