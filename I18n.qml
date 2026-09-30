pragma Singleton
import QtQuick
QtObject {
    id: root



    property string language: AppSettings ? AppSettings.language : "Русский"

    readonly property var _dict: {
        "Русский": {
            "nav.home":            "ГЛАВНАЯ",
            "nav.news":            "НОВОСТИ",
            "nav.clients":         "КЛИЕНТЫ",
            "nav.configs":         "КОНФИГИ",
            "nav.settings":        "НАСТРОЙКИ",
            "play.play":           "ИГРАТЬ",
            "play.download":       "СКАЧАТЬ И ИГРАТЬ",
            "play.loading":        "ЗАГРУЗКА…",
            "play.noclients":      "НЕТ КЛИЕНТОВ",
            "selector.hint":       "Выбрать клиент",
            "selector.none":       "не выбран",
            "news.title":          "НОВОСТИ",
            "news.all":            "Все новости →",
            "news.none":           "Нет новостей",
            "news.header":         "Новости",
            "clients.title":       "Клиенты",
            "clients.none":        "Нет клиентов",
            "clients.offline":     "Сервер недоступен и нет установленных клиентов",
            "picker.title":        "ВЫБОР КЛИЕНТА",
            "nick.label":          "НИК",
            "settings.design":     "Дизайн",
            "settings.game":       "Игра",
            "settings.common":     "Общие",
            "settings.about":      "О программе"
        },
        "English": {
            "nav.home":            "HOME",
            "nav.news":            "NEWS",
            "nav.clients":         "CLIENTS",
            "nav.configs":         "CONFIGS",
            "nav.settings":        "SETTINGS",
            "play.play":           "PLAY",
            "play.download":       "DOWNLOAD & PLAY",
            "play.loading":        "LOADING…",
            "play.noclients":      "NO CLIENTS",
            "selector.hint":       "Pick a client",
            "selector.none":       "not selected",
            "news.title":          "NEWS",
            "news.all":            "All news →",
            "news.none":           "No news yet",
            "news.header":         "News",
            "clients.title":       "Clients",
            "clients.none":        "No clients",
            "clients.offline":     "Server offline and no installed clients",
            "picker.title":        "PICK A CLIENT",
            "nick.label":          "NICK",
            "settings.design":     "Design",
            "settings.game":       "Game",
            "settings.common":     "General",
            "settings.about":      "About"
        },
        "Українська": {
            "nav.home":            "ГОЛОВНА",
            "nav.news":            "НОВИНИ",
            "nav.clients":         "КЛІЄНТИ",
            "nav.configs":         "КОНФІГИ",
            "nav.settings":        "НАЛАШТУВАННЯ",
            "play.play":           "ГРАТИ",
            "play.download":       "ЗАВАНТАЖИТИ І ГРАТИ",
            "play.loading":        "ЗАВАНТАЖЕННЯ…",
            "play.noclients":      "НЕМАЄ КЛІЄНТІВ",
            "selector.hint":       "Обрати клієнт",
            "selector.none":       "не вибрано",
            "news.title":          "НОВИНИ",
            "news.all":            "Усі новини →",
            "news.none":           "Немає новин",
            "news.header":         "Новини",
            "clients.title":       "Клієнти",
            "clients.none":        "Немає клієнтів",
            "clients.offline":     "Сервер недоступний і немає встановлених клієнтів",
            "picker.title":        "ВИБІР КЛІЄНТА",
            "nick.label":          "НІК",
            "settings.design":     "Дизайн",
            "settings.game":       "Гра",
            "settings.common":     "Загальні",
            "settings.about":      "Про програму"
        },
        "Қазақша": {
            "nav.home":            "БАСТЫ",
            "nav.news":            "ЖАҢАЛЫҚТАР",
            "nav.clients":         "КЛИЕНТТЕР",
            "nav.configs":         "КОНФИГТЕР",
            "nav.settings":        "БАПТАУЛАР",
            "play.play":           "ОЙНАУ",
            "play.download":       "ЖҮКТЕП ОЙНАУ",
            "play.loading":        "ЖҮКТЕЛУДЕ…",
            "play.noclients":      "КЛИЕНТ ЖОҚ",
            "selector.hint":       "Клиент таңдау",
            "selector.none":       "таңдалмаған",
            "news.title":          "ЖАҢАЛЫҚТАР",
            "news.all":            "Барлық жаңалықтар →",
            "news.none":           "Жаңалық жоқ",
            "news.header":         "Жаңалықтар",
            "clients.title":       "Клиенттер",
            "clients.none":        "Клиент жоқ",
            "clients.offline":     "Сервер қолжетімсіз, орнатылған клиент те жоқ",
            "picker.title":        "КЛИЕНТ ТАҢДАУ",
            "nick.label":          "НИК",
            "settings.design":     "Дизайн",
            "settings.game":       "Ойын",
            "settings.common":     "Жалпы",
            "settings.about":      "Бағдарлама туралы"
        },
        "Беларуская": {
            "nav.home":            "ГАЛОЎНАЯ",
            "nav.news":            "НАВІНЫ",
            "nav.clients":         "КЛІЕНТЫ",
            "nav.configs":         "КАНФІГІ",
            "nav.settings":        "НАЛАДЫ",
            "play.play":           "ГУЛЯЦЬ",
            "play.download":       "СПАМПАВАЦЬ І ГУЛЯЦЬ",
            "play.loading":        "ЗАГРУЗКА…",
            "play.noclients":      "НЯМА КЛІЕНТАЎ",
            "selector.hint":       "Выбраць кліент",
            "selector.none":       "не выбраны",
            "news.title":          "НАВІНЫ",
            "news.all":            "Усе навіны →",
            "news.none":           "Няма навін",
            "news.header":         "Навіны",
            "clients.title":       "Кліенты",
            "clients.none":        "Няма кліентаў",
            "clients.offline":     "Сервер недаступны і няма ўстаноўленых кліентаў",
            "picker.title":        "ВЫБАР КЛІЕНТА",
            "nick.label":          "НІК",
            "settings.design":     "Дызайн",
            "settings.game":       "Гульня",
            "settings.common":     "Агульныя",
            "settings.about":      "Пра праграму"
        }
    }

    function t(key) {
        var pack = _dict[language] || _dict["Русский"]
        return pack[key] || key
    }
}



