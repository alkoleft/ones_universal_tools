﻿// ВнешниеОбработки.Создать("CodeConsole83").ПоместитьЗапросВоВременноеХранилище(Запрос);

Функция ПоместитьЗапрос(Запрос, Знач Адрес = Неопределено) Экспорт 
	
	Если Адрес = Неопределено Тогда 
		Адрес = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьДанныеЗапроса(Запрос), Адрес);
	
КонецФункции

Функция ПоместитьЗапросСКД(СхемаКомпоновкиДанных, Настройки, Знач Адрес = Неопределено) Экспорт 
	
	Если Адрес = Неопределено Тогда 
		Адрес = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьДанныеЗапросаСКД(СхемаКомпоновкиДанных, Настройки), Адрес);
	
КонецФункции

Функция ПолучитьДанныеЗапроса(Запрос) Экспорт 
	
	#Если Клиент Тогда
		Запрос = Новый Запрос;
	#КонецЕсли	
	
	ДанныеЗапроса = Новый Структура("Текст, Параметры");

	ЗаполнитьЗначенияСвойств(ДанныеЗапроса, Запрос);
		
	Если Запрос.МенеджерВременныхТаблиц <> Неопределено Тогда 
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		
		ВременныеТаблицыЗапроса = Новый Соответствие;
		Для Каждого Пакет Из СхемаЗапроса.ПакетЗапросов Цикл 
			
			Если ЗначениеЗаполнено(Пакет.ТаблицаДляПомещения) Тогда 
				
				ВременныеТаблицыЗапроса.Вставить(ВРег(Пакет.ТаблицаДляПомещения), Истина);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстыУстановкиВТ = "";
		
		
		Для каждого Таблица Из Запрос.МенеджерВременныхТаблиц.Таблицы Цикл 
			
			Если ВременныеТаблицыЗапроса[ВРег(Таблица.ПолноеИмя)] = Неопределено Тогда 
				
				ДанныеЗапроса.Параметры.Вставить(Таблица.ПолноеИмя, Таблица.ПолучитьДанные().Выгрузить());
				ТекстыУстановкиВТ = ТекстыУстановкиВТ + СтрШаблон("ВЫБРАТЬ * ПОМЕСТИТЬ %1 ИЗ &%1%2;%2", Таблица.ПолноеИмя, Символы.ПС);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ДанныеЗапроса.Текст = ТекстыУстановкиВТ + ДанныеЗапроса.Текст;
		
	КонецЕсли;
	
	Возврат ДанныеЗапроса;
	
КонецФункции

Функция ПолучитьДанныеЗапросаСКД(СхемаКомпоновкиДанных, Знач Настройки) Экспорт 
	
	Настройки = ПолучитьНастройки(Настройки);
	
	#Если Клиент Тогда
	    Схема = Новый СхемаКомпоновкиДанных; 	
	    Настройки = Новый НастройкиКомпоновкиДанных; 	
	#КонецЕсли
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ?(Настройки = Неопределено, СхемаКомпоновкиДанных.НастройкиПоУмолчанию, Настройки));
	
	ДанныеЗапроса = Новый Структура("Текст, Параметры", "", Новый Структура);

	ДанныеЗапроса.Текст = МакетКомпоновки.НаборыДанных[0].Запрос;
	
	Для Каждого Параметр Из МакетКомпоновки.ЗначенияПараметров Цикл 
				
		ДанныеЗапроса.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
		
	КонецЦикла;
	
	Возврат ДанныеЗапроса;
	
КонецФункции

Функция ПолучитьНастройки(Компановщик)
	
	ТипКомпановщика = ТипЗнч(Компановщик);
	
	Если ТипКомпановщика = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда 

		Возврат Компановщик.ПолучитьНастройки();
		
	ИначеЕсли ТипКомпановщика = Тип("СхемаКомпоновкиДанных") Тогда 
		
		Возврат Компановщик.НастройкиПоУмолчанию;
		
	ИначеЕсли ТипКомпановщика = Тип("НастройкиКомпоновкиДанных") Тогда 
		
		Возврат Компановщик;
		
	ИначеЕсли ТипКомпановщика = Тип("ДинамическийСписок") Тогда
		
		Возврат Компановщик.КомпоновщикНастроек.Настройки;
		
	иначе 
		Возврат Неопределено; 
	КонецЕсли;
КонецФункции