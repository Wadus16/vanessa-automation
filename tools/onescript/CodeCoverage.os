﻿#Использовать v8runner

Перем ОсновнаяВерсияПлатформы;

// Проверяет наличия каталога и в случае его отсутствия создает новый.
//
// Параметры:
//  Каталог - Строка - Путь к каталогу, существование которого нужно проверить.
//
// Возвращаемое значение:
//  Булево - признак существования каталога.
//
// Взято из https://infostart.ru/public/537028/
Функция ОбеспечитьКаталог(Знач Каталог)
	
	Файл = Новый Файл(Каталог);
	Если Не Файл.Существует() Тогда
		Попытка 
			СоздатьКаталог(Каталог);
		Исключение
			Сообщить(СтрШаблон(НСтр("ru='Не удалось создать каталог %1.
|%2';en='Failed to create directory %1.
|%2'"), Каталог, ИнформацияОбОшибке()));
			Возврат Ложь;
		КонецПопытки;
	ИначеЕсли Не Файл.ЭтоКаталог() Тогда 
		Сообщить(СтрШаблон(НСтр("ru='Каталог %1 не является каталогом.';en='Directory %1 is not a directory.'"), Каталог));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Перемещаят найденные по маскам файлы с сохранением пути.
//
// Параметры:
//  КаталогКуда - Строка - Путь к каталогу в который переносятся файлы;
//  КаталогиОткуда 		 - Массив - Пути к каталогам в которых осуществляется поиск файлов;
//  МассивМасок 		 - Массив - Маски, по которым осуществляется поиск файлов.
//
// Взято из https://infostart.ru/public/537028/
Процедура СкопироватьФайлыВКаталог(КаталогКуда, КаталогиОткуда, МассивМасок, МассивИсключений)
 	
 	Для Каждого КаталогПоиска Из КаталогиОткуда Цикл
		КаталогПоискаОбъект = Новый Файл(КаталогПоиска);
		Если НЕ КаталогПоискаОбъект.Существует() Тогда
			Сообщить(НСтр("ru='Каталог не найден.';en='Folder not found.'"));
			Продолжить;
		КонецЕсли;
		
		Для Каждого Маска Из МассивМасок Цикл
		
			МассивФайлов = НайтиФайлы(КаталогПоиска, Маска, Истина); 
			Для Каждого НайденныйФайл Из МассивФайлов Цикл
				
				НовыйПуть = СтрЗаменить(НайденныйФайл.Путь, КаталогПоиска, КаталогКуда);
				
				НадоСкопировать = Истина;
				Для Каждого Стр Из МассивИсключений Цикл
					Если Найти(НовыйПуть,Стр) > 0 Тогда
						НадоСкопировать = Ложь;
						Прервать;
					КонецЕсли;	 
				КонецЦикла;	 
				
				Если НЕ НадоСкопировать Тогда
					Продолжить;
				КонецЕсли;	 
				
				
				НовоеИмя = НайденныйФайл.Имя; 			
				
				Если НЕ ОбеспечитьКаталог(НовыйПуть) Тогда 
					Продолжить; 
				КонецЕсли;
				
				Если НайденныйФайл.ЭтоКаталог() Тогда
					Продолжить;
				КонецЕсли;	 
				
				ИмяФайлаДляПеремещения = ОбъединитьПути(НовыйПуть, НовоеИмя);
				УдалитьФайлы(ИмяФайлаДляПеремещения);
				
				Попытка
					НадоСкопировать = Истина;
					Для Каждого Стр Из МассивИсключений Цикл
						Если Найти(ИмяФайлаДляПеремещения,Стр) > 0 Тогда
							НадоСкопировать = Ложь;
							Прервать;
						КонецЕсли;	 
					КонецЦикла;	 
					
					Если НЕ НадоСкопировать Тогда
						Продолжить;
					КонецЕсли;	 
					
					КопироватьФайл(НайденныйФайл.ПолноеИмя,ИмяФайлаДляПеремещения);
				Исключение
					Сообщить(СтрШаблон(НСтр("ru='Не удалось скопировать файл:
|%1';en='Failed to copy file:
|%1'"), ОписаниеОшибки()));
					Продолжить;
				КонецПопытки;
								
				ФайлНаДиске = Новый Файл(ОбъединитьПути(НовыйПуть, НовоеИмя));
			    Если НЕ ФайлНаДиске.Существует() Тогда
					Сообщить(НСтр("ru='Не удалось корректно скопировать файл.';en='Failed to correctly copy file.'"));
					Продолжить;
			    КонецЕсли;
			КонецЦикла;	
		
		КонецЦикла;	

  	КонецЦикла;	

КонецПроцедуры

Функция ПолучитьВременныйКаталог()
	ИмяФайла = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяФайла);
	Возврат ИмяФайла;
КонецФункции	

Процедура ОчиститьКаталог(Каталог)
	ТаблицаКаталогов = Новый ТаблицаЗначений;
	ТаблицаКаталогов.Колонки.Добавить("ПолныйПуть");
	ТаблицаКаталогов.Колонки.Добавить("Длина");
	
	//Сообщить("КаталогОткуда="+КаталогОткуда);
	//Сообщить("КаталогКуда="+КаталогКуда);
	
	Файлы = НайтиФайлы(Каталог,"*",Истина);
	Для Каждого Файл Из Файлы Цикл
		Если Файл.ЭтоКаталог() Тогда
			СтрокаТаблицаКаталогов = ТаблицаКаталогов.Добавить();
			СтрокаТаблицаКаталогов.ПолныйПуть = Файл.ПолноеИмя;
			СтрокаТаблицаКаталогов.Длина      = СтрДлина(Файл.ПолноеИмя);
			Продолжить;
		КонецЕсли;	 
		
		УдалитьФайлы(Файл.ПолноеИмя);
	КонецЦикла;	
	
	ТаблицаКаталогов.Сортировать("Длина убыв");
	
	Для Каждого СтрокаТаблицаКаталогов Из ТаблицаКаталогов Цикл
		//Сообщить(СтрокаТаблицаКаталогов.ПолныйПуть);
		УдалитьФайлы(СтрокаТаблицаКаталогов.ПолныйПуть);
	КонецЦикла;	
КонецПроцедуры 

Процедура ОбработатьФайлConfiguration_xml(ИмяФайла,Версия)
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайла,"UTF-8");
	
	ЗТ = Новый ЗаписьТекста(ИмяВременногоФайла,"UTF-8",,Ложь); 
	
	ЗначениеВерсия = "DontUse";
	Если Версия = "8.3.9" Тогда
		ЗначениеВерсия = "VERSION" + СтрЗаменить(Версия,".","_");
	ИначеЕсли (Версия >= "8.3.10") И (СтрДлина(Версия) = 6) Тогда
		ЗначениеВерсия = "VERSION" + СтрЗаменить(Версия,".","_");
	КонецЕсли;	 
	
	
	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;	 
		
		Если Найти(Стр,"<CompatibilityMode>") > 0 Тогда
			Стр = "			<CompatibilityMode>" + ЗначениеВерсия + "</CompatibilityMode>";
		КонецЕсли;	 
		
		ЗТ.ЗаписатьСтроку(Стр); 
	КонецЦикла;	
	
	Текст.Закрыть();
	ЗТ.Закрыть();
	
	КопироватьФайл(ИмяВременногоФайла,ИмяФайла);
	УдалитьФайлы(ИмяВременногоФайла);
КонецПроцедуры

Процедура СоздатьПустуюБазу(ПутьКБазе, Исходники)
	Сообщить("Создание базы.");
	
	Файл = Новый Файл(ПутьКБазе); 
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(ПутьКБазе);
	Иначе	
		ОчиститьКаталог(ПутьКБазе)
	КонецЕсли;	 
	
	
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором();
	путьКПлатформе = УправлениеКонфигуратором.ПолучитьПутьКВерсииПлатформы(ОсновнаяВерсияПлатформы);
	
	УправлениеКонфигуратором.СоздатьФайловуюБазу(ПутьКБазе);
	
	УправлениеКонфигуратором.УстановитьКонтекст("/F" + ПутьКБазе + "\","","");
	
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/LoadConfigFromFiles """ + Исходники + """"); 

	УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	
	
	//теперь выгрузим конфу в файлы ещё раз и заменим параметр CompatibilityMode на DontUse, чтобы гарантировать, что не используется режим совместимости
	ВременныйКаталог = ПолучитьВременныйКаталог();
	
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/DumpConfigToFiles  """ + ВременныйКаталог + """"); 
	УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	
	//Сообщить("ВременныйКаталог="+ВременныйКаталог);
	ОбработатьФайлConfiguration_xml(ВременныйКаталог + "\Configuration.xml",ОсновнаяВерсияПлатформы);
	
	//теперь загрузим конфу обратно
	ПараметрыЗапуска = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/LoadConfigFromFiles  """ + ВременныйКаталог + """"); 
	УправлениеКонфигуратором.ВыполнитьКоманду(ПараметрыЗапуска);
	
	ОчиститьКаталог(ВременныйКаталог);
	

	УправлениеКонфигуратором.ОбновитьКонфигурациюБазыДанных();
	
	
КонецПроцедуры 

Функция ОбернутьВКавычки(Стр)
	Возврат """" + Стр + """"; 
КонецФункции	 

Функция ПолучитьСтрокуВызоваSikuli()
	ЭтоLinux = Ложь;
	Если ЭтоLinux Тогда
		Возврат "runsikulix -r ";
	Иначе
		Возврат "runsikulix -r ";
	КонецЕсли;
КонецФункции

Функция ВыполнитьSikuliСкрипт(СтрокаКоманды, ЖдатьОкончания = -1)
	Стр = ПолучитьСтрокуВызоваSikuli() + " " + СтрокаКоманды;
	
	Сообщить(Стр);
	retCode = -1;
	ЗапуститьПриложение(Стр,,Истина,retCode);
	
	Статус = retCode;
	
	Возврат Статус;
КонецФункции

Функция ПолучитьКаталогBinПлатформы()
	УправлениеКонфигуратором = Новый УправлениеКонфигуратором();
	путьКПлатформе = УправлениеКонфигуратором.ПолучитьПутьКВерсииПлатформы(ОсновнаяВерсияПлатформы);
	
	Файл = Новый Файл(путьКПлатформе); 
	Возврат Файл.Путь;
КонецФункции	 

Процедура ЗапуститьКонфигураторБазы(ПутьКБазе,ПутьКПроекту)
	Сообщить("Запуск конфигуратора.");
	
	КаталогBin = ПолучитьКаталогBinПлатформы();
	
	СтрокаКоманды = ОбернутьВКавычки(КаталогBin + "1cv8") + " DESIGNER /F" + ОбернутьВКавычки(ПутьКБазе);
	
	Сообщить(СтрокаКоманды);
	retCode = -1;
	ЗапуститьПриложение(СтрокаКоманды,,Ложь,retCode);
	
КонецПроцедуры

Функция ПолучитьАдресОтладчика(ПутьКПроекту)
	ВременныйФайл = ПолучитьИмяВременногоФайла("txt");
	
	ИмяСкрипта = ПутьКПроекту + "\tools\Sikuli\GetDebuggerUrl.sikuli --args """ + ВременныйФайл + """";
	Статус = ВыполнитьSikuliСкрипт(ИмяСкрипта);
	Если Статус <> 0 Тогда
		ВызватьИсключение "Не получилось выполнить скрипт копирующий в буфер обмена адрес отладчика.";
	КонецЕсли;	 
	
	
	Файл = Новый Файл(ВременныйФайл); 
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение "Не найден файл с адресом отладчика.";
	КонецЕсли;	 
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ВременныйФайл,"UTF-8");
	Стр = Текст.Прочитать();
	Текст.Закрыть();
	
	УдалитьФайлы(ВременныйФайл);
	
	Возврат Стр;
КонецФункции	

Функция СоздатьJsonДляЗапускаТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,ИмяJson);
	Сообщить("Создание JOSN для запуска тестов.");
	
	ПутьКJson = ПутьКПроекту + "\tools\JSON\" + ИмяJson;
	НовыйПутьКJson = ПутьКБазе + "\" + ИмяJson;
	УдалитьФайлы(НовыйПутьКJson);
	
	КопироватьФайл(ПутьКJson,НовыйПутьКJson);
	
	//Установка адреса отладчика
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(НовыйПутьКJson,"UTF-8");
	Стр = Текст.Прочитать();	
	Текст.Закрыть();
	
	//СистемнаяИнформация = Новый СистемнаяИнформация;
	
	ФайлСтатусаВыполненияСценариев = ПутьКБазе + "\BuildStatus.log";
	ФайлСтатусаВыполненияСценариев = СтрЗаменить(ФайлСтатусаВыполненияСценариев,"\","/");
	
	Стр = СтрЗаменить(Стр,"{АдресОтладчика}",АдресОтладчика);
	Стр = СтрЗаменить(Стр,"{ФайлСтатусаВыполненияСценариев}",ФайлСтатусаВыполненияСценариев);
	
	УдалитьФайлы(НовыйПутьКJson);
	ЗТ = Новый ЗаписьТекста(НовыйПутьКJson,"UTF-8",,Истина); 
	ЗТ.Записать(Стр); 
	ЗТ.Закрыть();
	
	Возврат НовыйПутьКJson;
	
КонецФункции	 

Процедура ЗапуститьСессиюТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,ИмяJson,ДопПараметр,UF)
	Сообщить("Запуск сессии тестирования.");
	
	КаталогBin = ПолучитьКаталогBinПлатформы();

	ДопПараметрЗапуска = "/TESTMANAGER /DebuggerURL %1 /Debug /Execute ""%2"" /C""StartFeaturePlayer;VBParams=%3"" " + ДопПараметр;
	ДопПараметрЗапуска = СтрШаблон(ДопПараметрЗапуска,АдресОтладчика,ПутьКПроекту + "\vanessa-automation.epf",ИмяJson);
	
	Если UF Тогда
		ПутьКПлатформе = ОбернутьВКавычки(КаталогBin + "1cv8c");
	Иначе	
		ПутьКПлатформе = ОбернутьВКавычки(КаталогBin + "1cv8");
	КонецЕсли;	 
	
	СтрокаКоманды = ПутьКПлатформе + " ENTERPRISE /F" + ОбернутьВКавычки(ПутьКБазе) + " " + ДопПараметрЗапуска;
	
	Сообщить(СтрокаКоманды);
	retCode = -1;
	ЗапуститьПриложение(СтрокаКоманды,,Истина,retCode);
КонецПроцедуры 

Процедура ВключитьСнятиеЗамеров(ПутьКПроекту)
	Сообщить("Включение снятия замеров.");
	
	ИмяСкрипта = ПутьКПроекту + "\tools\Sikuli\StartZamer.sikuli";
	Статус = ВыполнитьSikuliСкрипт(ИмяСкрипта);
	Если Статус <> 0 Тогда
		ВызватьИсключение "Не получилось выключить снятие замеров производительности.";
	КонецЕсли;	 
КонецПроцедуры 

Процедура СохранитьЗамерыВКаталог(ПутьКПроекту,Каталог)
	Сообщить("Сохранение замеров в каталог.");
	
	Файл = Новый Файл(Каталог); 
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(Каталог);
	КонецЕсли;	 
	
	ИмяСкрипта = ПутьКПроекту + "\tools\Sikuli\SaveZamer.sikuli --args """ + Каталог + """";
	Статус = ВыполнитьSikuliСкрипт(ИмяСкрипта);
	Если Статус <> 0 Тогда
		ВызватьИсключение "Не получилось выполнить скрипт копирующий в буфер обмена адрес отладчика.";
	КонецЕсли;	 
	
КонецПроцедуры 

Процедура ЗаменитьПутиВJsonНаАбсолютные(ИмяФайла,Знач ПутьКПроекту)
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайла,"UTF-8");
	Стр = Текст.Прочитать();
	Текст.Закрыть();
	
	УдалитьФайлы(ИмяФайла);
	
	Если Прав(ПутьКПроекту,1) = "/" ИЛИ Прав(ПутьКПроекту,1) = "\" Тогда
		ПутьКПроекту = Лев(ПутьКПроекту,СтрДлина(ПутьКПроекту)-1);
	КонецЕсли;	 
	
	Стр = СтрЗаменить(Стр,"""./","""" + СтрЗаменить(ПутьКПроекту,"\","/") + "/");
	
	
	ЗТ = Новый ЗаписьТекста(ИмяФайла,"UTF-8",,Истина); 
	ЗТ.Записать(Стр); 
	ЗТ.Закрыть();
	
	
КонецПроцедуры 

Процедура ПроверитьЧтоНеБылоОшибок(ПутьКПроекту,ПутьКБазе)
	Сообщить("Проверка, что не было ошибок во время выполнения тестов.");
	
	ПутьФайлСтатусаВыполненияСценариев = ПутьКБазе + "\BuildStatus.log";
	
	Файл = Новый Файл(ПутьФайлСтатусаВыполненияСценариев); 
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение "Не найден файл: " + ПутьФайлСтатусаВыполненияСценариев;
	КонецЕсли;	 
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ПутьФайлСтатусаВыполненияСценариев,"UTF-8");
	
	Стр = СокрЛП(Текст.Прочитать());
	Текст.Закрыть();
	
	Если Стр <> "0" Тогда
		Сообщить("Были ошибки во время выполнения тестов.");
	КонецЕсли;	 
	
	
КонецПроцедуры 

Процедура СобратьЗамерыUFОсновной(ПутьКПроекту,ПутьКБазе,КаталогЗамеров)
	Сообщить("Сбор замеров UF.");
	
	СоздатьПустуюБазу(ПутьКБазе, ПутьКПроекту + "\lib\CF\83");
	ЗапуститьКонфигураторБазы(ПутьКБазе,ПутьКПроекту);
	
	//Сообщить("Вернуть!!!!!!!!!!!!!!!!");
	
	АдресОтладчика = ПолучитьАдресОтладчика(ПутьКПроекту);
	Сообщить("АдресОтладчика="+АдресОтладчика);
	
	ВключитьСнятиеЗамеров(ПутьКПроекту);
	
	ИмяJson = СоздатьJsonДляЗапускаТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,"VBParams8316UF_CodeCoverage.json");
	ЗаменитьПутиВJsonНаАбсолютные(ИмяJson,ПутьКПроекту);
	
	ЗапуститьСессиюТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,ИмяJson,"",Истина);
	
	ПроверитьЧтоНеБылоОшибок(ПутьКПроекту,ПутьКБазе);
	
	sleep(50000);
	
	СохранитьЗамерыВКаталог(ПутьКПроекту,КаталогЗамеров);
	
КонецПроцедуры 

Процедура СобратьЗамерыOFОсновной(ПутьКПроекту,ПутьКБазе,КаталогЗамеров)
	Сообщить("Сбор замеров OF.");
	
	СоздатьПустуюБазу(ПутьКБазе, ПутьКПроекту + "\lib\CF\83");
	ЗапуститьКонфигураторБазы(ПутьКБазе,ПутьКПроекту);
	
	//Сообщить("Вернуть!!!!!!!!!!!!!!!!");
	
	АдресОтладчика = ПолучитьАдресОтладчика(ПутьКПроекту);
	Сообщить("АдресОтладчика="+АдресОтладчика);
	
	ВключитьСнятиеЗамеров(ПутьКПроекту);
	
	ИмяJson = СоздатьJsonДляЗапускаТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,"VBParams8316OF_CodeCoverage.json");
	ЗаменитьПутиВJsonНаАбсолютные(ИмяJson,ПутьКПроекту);
	
	ЗапуститьСессиюТестов(ПутьКПроекту,ПутьКБазе,АдресОтладчика,ИмяJson,"/RunModeOrdinaryApplication",Ложь);
	
	ПроверитьЧтоНеБылоОшибок(ПутьКПроекту,ПутьКБазе);
	
	sleep(50000);
	
	СохранитьЗамерыВКаталог(ПутьКПроекту,КаталогЗамеров);
	
КонецПроцедуры 

Процедура ПроверитьКорректностьПараметров(ПутьКПроекту, ПутьКБазе, КаталогЗамеров)
	Файл = Новый Файл(ПутьКПроекту); 
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(ПутьКПроекту);
	КонецЕсли;	 
	
	Файл = Новый Файл(ПутьКПроекту); 
	Если НЕ Файл.Существует() Тогда
		ВызватьИсключение "Не найден каталог <" + ПутьКПроекту + ">";
	КонецЕсли;	 
	
	Файл = Новый Файл(КаталогЗамеров + "\pff"); 
	Если НЕ Файл.Существует() Тогда
		СоздатьКаталог(КаталогЗамеров + "\pff");
	КонецЕсли;	 
	
	ОчиститьКаталог(КаталогЗамеров + "\pff");
	
	ОчиститьКаталог(ПутьКПроекту + "\tools\ServiceBases\allurereport");
	ОчиститьКаталог(ПутьКПроекту + "\tools\ServiceBases\cucumber");
	ОчиститьКаталог(ПутьКПроекту + "\tools\ServiceBases\junitreport");
	
КонецПроцедуры 

Процедура СкопироватьПроект(ПутьКПроекту,КаталогЗамеров)
	КаталогКуда = КаталогЗамеров + "\vanessa-automation";
	ОчиститьКаталог(КаталогКуда);
	
	ПутьИсточник = ПутьКПроекту;
	
	КаталогиОткуда = Новый Массив;
	КаталогиОткуда.Добавить(ПутьИсточник);
	
	МассивМасок = Новый Массив;
	МассивМасок.Добавить("*");
	
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить(".git");
	
	СкопироватьФайлыВКаталог(КаталогКуда, КаталогиОткуда, МассивМасок, МассивИсключений);
	
КонецПроцедуры 

Процедура ВыполнитьОбработку(ПутьКПроекту, ПутьКБазе, КаталогЗамеров)
	
	ПроверитьКорректностьПараметров(ПутьКПроекту, ПутьКБазе, КаталогЗамеров);
	
	СкопироватьПроект(ПутьКПроекту,КаталогЗамеров);
	
	СобратьЗамерыUFОсновной(ПутьКПроекту,ПутьКБазе,КаталогЗамеров + "\pff\UFMain");
	СобратьЗамерыOFОсновной(ПутьКПроекту,ПутьКБазе,КаталогЗамеров + "\pff\OFMain");
	
КонецПроцедуры 

ОсновнаяВерсияПлатформы = "8.3.16";

Если АргументыКоманднойСтроки.Количество() = 0 Тогда
	Сообщить("Не переданы параметры!");
ИначеЕсли АргументыКоманднойСтроки.Количество() <>  3 Тогда
	Сообщить("Скрипт принимает три параметра!");
Иначе
	//параметры
	//1. путь к проекту
	//2. путь к базе
	//3. путь к каталогу, где будут сохранены замеры
	ВыполнитьОбработку(АргументыКоманднойСтроки[0],АргументыКоманднойСтроки[1],АргументыКоманднойСтроки[2]);
КонецЕсли;

Сообщить("Обработка завершена.");
Sleep(1000);


