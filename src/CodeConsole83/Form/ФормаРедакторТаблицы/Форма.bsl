﻿
#Область Работа_с_формой

&НаСервере
процедура СоздатьКолонкиТЗ(Колонки)
	МассивРеквизитов = Новый Массив;
	
	Для Каждого Колонка из Колонки Цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		
		РеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "ТаблицаДанных");
		МассивРеквизитов.Добавить(РеквизитФормы);
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(МассивРеквизитов);
	
	Для Каждого Колонка из Колонки цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		ИмяКолонки = "ТаблицаДанных" + Колонка.Имя;
		Элемент = ЭтаФорма.Элементы.Найти(ИмяКолонки);
		
		Если Элемент = Неопределено Тогда
			
			Элемент = ЭтаФорма.Элементы.Добавить(ИмяКолонки, Тип("ПолеФормы"), Элементы.ТаблицаДанных);
			//Попытка
			Элемент.ПутьКДанным = "ТаблицаДанных." + Колонка.Имя;
			//Исключение
			//КонецПопытки;
			
		КонецЕсли;
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.Заголовок = Колонка.Имя;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКолонки(Колонки)
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	
	Для Каждого Колонка из Колонки цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		
		МассивУдаляемыхРеквизитов.Добавить("ТаблицаДанных."+Колонка.Имя);
	КонецЦикла;
	
	ЭтаФорма.ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
	
	Для Каждого Колонка из Колонки цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		ИмяКолонки = "ТаблицаДанных" + Колонка.Имя;
		Элемент = ЭтаФорма.Элементы.Найти(ИмяКолонки);
		ЭтаФорма.Элементы.Удалить(Элемент);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти //Работа_с_формой


#Область События_формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресДанныхТЗ = Параметры.АдресДанныхТЗ;
	
	Таблица = ПолучитьИзВременногоХранилища(АдресДанныхТЗ);
	
	Если Таблица <> Неопределено Тогда 
		
		ОбновитьКолонкиТЗ(, Таблица.Колонки);
		
		ТаблицаДанных.Загрузить(Таблица);
	
	Иначе
		
		ОткрытьФормуНастроек = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрытьФормуНастроек Тогда 
		
		НастроитьКолонки(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //События_формы

&НаСервере
Процедура ОбновитьКолонкиТЗ(СтарыеКолонки = Неопределено, НовыеКолонки)
	
	Если СтарыеКолонки <> Неопределено Тогда 
		
		УдалитьКолонки(СтарыеКолонки);
		
	КонецЕсли;
	
	СоздатьКолонкиТЗ(НовыеКолонки);
	
	РеквизитыТаблицы.Очистить();
	Для Каждого Колонка Из НовыеКолонки Цикл 
		
		Стр = РеквизитыТаблицы.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, Колонка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТЗ(ОписаниеКолонок)
	
	ТаблицаПосле = Новый ТаблицаЗначений;
	
	ТаблицаДо = РеквизитФормыВЗначение("ТаблицаДанных");
	
	Для Каждого Колонка Из ОписаниеКолонок Цикл 
		
		ТаблицаПосле.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения, Колонка.Заголовок);
		
	КонецЦикла;
	
	Если ТаблицаДо <> Неопределено Тогда
		
		Для инд = 0 По ТаблицаДо.Количество() - 1 Цикл 
			
			Стр = ТаблицаПосле.Добавить();
			
			ЗаполнитьЗначенияСвойств(Стр, ТаблицаДо[инд]);
			
		КонецЦикла;

	КонецЕсли;	
	
	ОбновитьКолонкиТЗ(?(ТаблицаДо = Неопределено, Неопределено, ТаблицаДо.КОлонки), ТаблицаПосле.Колонки);
	
	ТаблицаДанных.Загрузить(ТаблицаПосле);
	
КонецПроцедуры

#Область Команды

&НаКлиенте
Процедура НастроитьКолонки(Команда)

	Оповещение = Новый ОписаниеОповещения("ПослеНастройкиКолонок", ЭтотОбъект);
	ОткрытьФорму("ВнешняяОбработка.КонсольКода83.Форма.ФормаНастройкаТаблицы", Новый Структура("Данные", РеквизитыТаблицы), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастройкиКолонок(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Неопределено Тогда 
		
		ОбновитьТЗ(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТаблицу(Команда)
	
	СохранитьДанныеТаблицыНаСервере();
	Закрыть(Истина);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеТаблицыНаСервере()
	
	ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТаблицаДанных"), АдресДанныхТЗ);
	
КонецПроцедуры
#КонецОбласти //Команды

