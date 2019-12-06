$(function () {

	$('.date').pickmeup({
		format		: 'Y.m.d',
		position	: 'bottom',
		hide_on_select	: true ,

		locale: {
			days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"],
			daysShort: ["Вос", "Пон", "Вто", "Сре", "Чет", "Пят", "Суб", "Вос"],
			daysMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
			months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
			monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
		},

		change : function (val) {
            		$('.date').val(val);
			window.location.href="http://medcenter-gp.ru/?page=reception&date="+$('.date').val(val).pickmeup('get_date', 'true');
		}
	});
});

//