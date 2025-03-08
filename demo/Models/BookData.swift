//
//  BookData.swift
//  demo
//
//  Created by Aagam Bakliwal on 2/26/25.
//

import Foundation

struct Book: Hashable, Identifiable, Codable {
    let name: String
    let hindiName: String
    let author: String
    let pgNum: Int
    let id: UUID?
    
    init(name: String, hindiName: String, author: String, pgNum: Int, id: UUID? = UUID()) {
        self.name = name
        self.hindiName = hindiName
        self.author = author
        self.pgNum = pgNum
        self.id = id
    }
}


//struct Category: Hashable, Identifiable{
//    let name: String
//    let books: [Book]
//    let id = UUID()
//}

//let sections: [Category] = [
//    Category(name: "Poojan",
//            books: [Book(name: "Adi"),
//                    Book(name: "Mahavir")]
//            ),
//    Category(name: "Path",
//            books: [Book(name: "Vee"),
//                    Book(name: "Jinendra Archana")]
//            )
//]

let sections: [String: [Book]] = [
    "Stavan": [
        Book(name: "Jinpoojan Rahasya", hindiName: "जिनपूजन रहस्य", author: "पं. रतनचंद भारिल्ल", pgNum: 1),
        Book(name: "Jinendra Vandana", hindiName: "जिनेंद्र वंदना", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 47),
        Book(name: "Darshan Path", hindiName: "दर्शन पाठ", author: "-", pgNum: 51),
        Book(name: "Dev Stuti", hindiName: "देवस्तुति (प्रभु पतितपावन...)", author: "श्री बुधजन", pgNum: 52),
        Book(name: "Darshan Stuti", hindiName: "दर्शन स्तुति (अतिपुण्य उदय...)", author: "श्री अमरचंदजी", pgNum: 53),
        Book(name: "Darshan Stuti 2", hindiName: "दर्शन स्तुति (सकलराश...)", author: "पं. दौलतरामजी", pgNum: 54),
        Book(name: "Darshan Path 2", hindiName: "दर्शन पाठ (दर्शन श्री देवाधिदेव का...)", author: "श्री युगलजी", pgNum: 56),
        Book(name: "Aaradhana Path", hindiName: "आराधना पाठ (मैं देव नित...)", author: "पं. घनतराय", pgNum: 57),
        Book(name: "Dev Stuti", hindiName: "देव स्तुति (वीतराग सर्वज्ञ हितकर...)", author: "-", pgNum: 58)
        ],
    "Poojan": [
        Book(name: "Jalabhishek Path", hindiName: "जलाभिषेक पाठ", author: "श्री हरसरायजी", pgNum: 59),
       Book(name: "Prakshal Path", hindiName: "प्रक्षाल पाठ", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 62),
       Book(name: "Pratima Prakshal Path", hindiName: "प्रतीमा प्रक्षाल पाठ", author: "पं. अभयकुमारजी", pgNum: 64),
       Book(name: "Vinay Path", hindiName: "विनय पाठ", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 67),
       Book(name: "Vinay Path 2", hindiName: "विनय पाठ", author: "-", pgNum: 69),
       Book(name: "Pooja Peethika (Sanskrit)", hindiName: "पूजा पीठिका (संस्कृत)", author: "-", pgNum: 71),
       Book(name: "Pooja Peethika (Hindi)", hindiName: "पूजा पीठिका (हिन्दी)", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 74),
       Book(name: "Swasti Mangal Path", hindiName: "स्वस्ति मंगल पाठ", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 77),
       Book(name: "Dev Shastra Guru Poojan", hindiName: "देव-शास्त्र-गुरु पूजन", author: "पंडित घनतरायजी", pgNum: 79),
       Book(name: "Dev Shastra Guru Poojan 2", hindiName: "देव-शास्त्र-गुरु पूजन", author: "श्री युगलजी", pgNum: 83),
       Book(name: "Dev Shastra Guru Poojan 3", hindiName: "देव-शास्त्र-गुरु पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 87),
       Book(name: "Dev Shastra Guru Poojan 4", hindiName: "देव-शास्त्र-गुरु पूजन", author: "डॉ. अखिल बंसल", pgNum: 91),
       Book(name: "Samuchay Poojan", hindiName: "समुच्चय पूजन", author: "ब्र. सरदारमलजी", pgNum: 94),
       Book(name: "Panch Parmeshthi Poojan", hindiName: "पंच परमेष्ठी पूजन", author: "श्री राजमलजी पचेया", pgNum: 97),
       Book(name: "Siddha Poojan", hindiName: "सिद्धपूजन", author: "आचार्य पद्मनन्दि", pgNum: 100),
       Book(name: "Siddha Poojan 2", hindiName: "सिद्धपूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 105),
       Book(name: "Siddha Poojan 3", hindiName: "सिद्धपूजन", author: "श्री युगलजी", pgNum: 109),
       Book(name: "Videsh Kshetra Stith Vidhaman Bees Tirthankar Poojan", hindiName: "विदेशक्षेत्र स्थित विद्धमान बीस तीर्थंकर पूजन", author: "पंडित घनतरायजी", pgNum: 113),
       Book(name: "Chaubis Tirthankar Poojan", hindiName: "चौबीस तीर्थंकर पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 116),
       Book(name: "Shri Vartaman Chaubisi Poojan", hindiName: "श्री वर्तमान चौबीसी पूजन", author: "कविवर वृष्टिदासदासजी", pgNum: 121),
       Book(name: "Samayik Poojan", hindiName: "समयिक पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 124),
       Book(name: "Das Lakshan Dharma Poojan", hindiName: "दशलक्षण धर्म पूजन", author: "पंडित घनतरायजी", pgNum: 129),
       Book(name: "Samyak-Tattva Dharma Poojan", hindiName: "सम्यक्तत्व धर्म पूजन", author: "पंडित घनतरायजी", pgNum: 132),
       Book(name: "Solahkaran Poojan", hindiName: "सोलहकारण पूजन", author: "पंडित घनतरायजी", pgNum: 134),
       Book(name: "Panchme Poojan", hindiName: "पंचमे पूजन", author: "पंडित घनतरायजी", pgNum: 135),
        Book(name: "Nandishwardweep Poojan", hindiName: "नन्दीश्वरद्वीप पूजन", author: "पंडित घनतरायजी", pgNum: 148),
            Book(name: "Adinath Jinpoojan", hindiName: "श्री आदिनाथ जिनपूजन", author: "पंडित जिनेन्द्रदासजी", pgNum: 152),
            Book(name: "Adinath Jinpoojan", hindiName: "श्री आदिनाथ जिनपूजन", author: "डॉ. अखिल बंसल", pgNum: 156),
            Book(name: "Chandraprabha Jinpoojan", hindiName: "श्री चन्द्रप्रभ जिनपूजन", author: "पंडित वृन्दावनदासजी", pgNum: 159),
            Book(name: "Chaitanya Vandana", hindiName: "चैतन्य वंदना", author: "पं. अभयकुमारजी", pgNum: 163),
            Book(name: "Shantinath Jinpoojan", hindiName: "श्री शांतिनाथ जिनपूजन", author: "पंडित वृन्दावनदासजी", pgNum: 164),
            Book(name: "Shantinath Poojan", hindiName: "श्री शांतिनाथ पूजन", author: "डॉ. अखिल बंसल", pgNum: 168),
            Book(name: "Parshvanath Jinpoojan", hindiName: "श्री पार्श्वनाथ जिनपूजन", author: "पंडित बद्रीप्रसादजी", pgNum: 172),
            Book(name: "Parshvanath Jinpoojan 2", hindiName: "श्री पार्श्वनाथ जिनपूजन", author: "डॉ. अखिल बंसल", pgNum: 177),
            Book(name: "Vardhaman Jinpoojan", hindiName: "श्री वर्धमान जिनपूजन", author: "पंडित वृन्दावनदासजी", pgNum: 181),
            Book(name: "Mahavir Poojan", hindiName: "श्री महावीर पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 185),
            Book(name: "Mahavir Poojan", hindiName: "श्री महावीर पूजन", author: "डॉ. अखिल बंसल", pgNum: 189),
            Book(name: "Panch Balayati Jinpoojan", hindiName: "श्री पंच बालायति जिनपूजन", author: "पं. अभयकुमारजी", pgNum: 192),
            Book(name: "Bharat-Bahubali Poojan", hindiName: "श्री भरत-बाहुबली पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 196),
            Book(name: "Bahubali Poojan", hindiName: "श्री बाहुबली पूजन", author: "श्री राजमल पचेया", pgNum: 201),
            Book(name: "Samkranti Poojan", hindiName: "श्री संक्रांति पूजन", author: "पंडित रंगलालजी", pgNum: 205),
            Book(name: "Saraswati Poojan", hindiName: "सरस्वती पूजन", author: "पंडित घनतरायजी", pgNum: 208),
            Book(name: "Akshay Tritiya Parva Poojan", hindiName: "अक्षय तृतीया पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 219),
            Book(name: "Rakshabandhan Parva Poojan", hindiName: "रक्षाबंधन पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 221),
            Book(name: "Veerashasan Jayanti Parva Poojan", hindiName: "वीराशासन जयंती पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 220),
            Book(name: "Kshamavani Poojan", hindiName: "क्षमावाणी पूजन", author: "श्री राजमलजी पचेया", pgNum: 224),
            Book(name: "Deepmala Parva Poojan", hindiName: "दीपमालिका पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 230),
            Book(name: "Shrut Panchami Parva Poojan", hindiName: "श्रुतपंचमी पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 235),
            Book(name: "Nirvana Kshetra Poojan", hindiName: "निर्वाणक्षेत्र पूजन", author: "पंडित घनतरायजी", pgNum: 239),
            Book(name: "Nirvana Kand Bhasha", hindiName: "निर्वाण काण्ड भाषा", author: "भैया भगवतीदासजी", pgNum: 242),
            Book(name: "Swayambhu Stotra (Bhasha)", hindiName: "स्वयम्भू-स्तोत्र (भाषा)", author: "श्री घनतरायजी", pgNum: 245),
            Book(name: "Chaturvish Tirthankar Ke Artha", hindiName: "चौबीस तीर्थंकरों के अर्थ", author: "-", pgNum: 246),
            Book(name: "Kootnim - Akritrim Chaityalayon Ke Artha", hindiName: "कूटनिम-अकृतिम चैत्यालयों के अर्थ", author: "-", pgNum: 252),
            Book(name: "Acharyavali", hindiName: "आचार्यावली", author: "-", pgNum: 254),
            Book(name: "Shanti Path (Sanskrit)", hindiName: "शांति पाठ (संस्कृत)", author: "-", pgNum: 261),
            Book(name: "Shanti Path (Bhasha)", hindiName: "शांति पाठ (भाषा)", author: "-", pgNum: 263),
            Book(name: "Shanti Path (Laghu)", hindiName: "शांति पाठ (लघु)", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 265),
            Book(name: "Shanti Path", hindiName: "शांति पाठ", author: "-", pgNum: 266)
    ],
    "Adhyatmik Path": [
        Book(name: "Neech Ninda (Samayik Path)", hindiName: "नीच निंदा (समायिक पाठ)", author: "श्री युगलजी", pgNum: 268),
        Book(name: "Amulya Tattva Vichar", hindiName: "अमूल्य तत्व विचार", author: "अनुवाद - श्री युगलजी", pgNum: 271),
        Book(name: "Alochana Path", hindiName: "आलोचना पाठ", author: "श्री जोहरीलालजी", pgNum: 272),
        Book(name: "Meri Bhavna", hindiName: "मेरी भावना", author: "श्री जुगलकिशोरजी मुख्तार", pgNum: 275),
        Book(name: "Vairagya Bhavna (Vajranabh Chakravarti)", hindiName: "वैराग्य भावना (वज्रनाभ चक्रवर्ती)", author: "अनु. पंडित भूधरदासजी", pgNum: 277),
        Book(name: "Chhahdhala", hindiName: "छहढाला", author: "पंडित दौलतरामजी", pgNum: 280),
        Book(name: "Bhaktamar Stotra", hindiName: "भक्तामर-स्तोत्र", author: "आचार्य मानतुंग", pgNum: 292),
        Book(name: "Bhaktamar Stotra (Hindi)", hindiName: "भक्तामर-स्तोत्र (हिन्दी)", author: "पंडित हेमराजजी", pgNum: 299),
        Book(name: "Bhaktamar: Kavya Kalash", hindiName: "भक्तामर : काव्य कलश", author: "डॉ. अखिल बंसल", pgNum: 306),
        Book(name: "Mahavir Ashtak Stotra", hindiName: "महावीराष्टक स्तोत्र", author: "कविवर भागचन्द", pgNum: 316),
        Book(name: "Mangalacharan", hindiName: "मंगलाचरण", author: "-", pgNum: 317),
        Book(name: "Samadhimaran (Hindi)", hindiName: "समाधिमरण (हिन्दी)", author: "पंडित सूरचन्दजी", pgNum: 319),
        Book(name: "Barah Bhavna", hindiName: "बारह भावना", author: "पंडित जयचन्दजी छाबड़ा", pgNum: 328),
        Book(name: "Barah Bhavna", hindiName: "बारह भावना", author: "पंडित भूधरदासजी", pgNum: 329),
        Book(name: "Tattvarth Sutra", hindiName: "तत्त्वार्थ सूत्र", author: "आचार्य उमास्वामी", pgNum: 330),

        ],
    "Bhakti": [
        // Bhakti Khand (Dev Bhakti)
        Book(name: "Ek Tumhi Adhar Ho Jag Mein", hindiName: "एक तुम्हीं आधार हो जग में...", author: "सौभाग्यमलजी", pgNum: 342),
        Book(name: "Tihare Dhyan Ki Murat", hindiName: "तिहारे ध्यान की मूरत...", author: "-", pgNum: 342),
        Book(name: "Mere Man Mandir Mein Aao", hindiName: "मेरे मन मंदिर में आओ...", author: "-", pgNum: 343),
        Book(name: "Nirakhu Ang-Ang Jinwar", hindiName: "निरखु अंग-अंग जिनवर...", author: "-", pgNum: 343),
        Book(name: "Aao Jin Mandir Mein Aao", hindiName: "आओ जिन मंदिर में आओ...", author: "-", pgNum: 344),
        Book(name: "Dhanya Dhanya Aaj Ghadi", hindiName: "धन्य धन्य आज घड़ी कैसी सुखकार है...", author: "सौभाग्यमलजी", pgNum: 345),
        Book(name: "Veer Prabhu Ke Ye Bol Tera Prabhu", hindiName: "वीर प्रभु के ये बोल तेरा प्रभु...", author: "-", pgNum: 345),

        // Shastra Bhakti
        Book(name: "He Jinwani Mata Tumko Lakhon", hindiName: "हे जिनवाणी माता तुमको लाखों...", author: "शिवरामजी", pgNum: 346),
        Book(name: "Jinwani Charan Bhakt Var Ganga", hindiName: "जिनवाणी चरण भक्ति वर गंगा...", author: "मानिकचंदजी", pgNum: 347),
        Book(name: "Jinwani Mata Ratnaraj", hindiName: "जिनवाणी माता रत्नराज...", author: "जयकुमारजी", pgNum: 347),
        Book(name: "Jin-Vain Sunat Mori Bhool", hindiName: "जिन-वैन सुनत मोरी भूल...", author: "पं. दौलतरामजी", pgNum: 348),
        Book(name: "Jinwani Mata Darshan Ki", hindiName: "जिनवाणी माता दर्शन की...", author: "-", pgNum: 348),
        Book(name: "Mahima Hai Agam Jinagam Ki", hindiName: "महिमा है अगम जिनागम की...", author: "पं. भागचन्दजी", pgNum: 348),
        Book(name: "Charanon Mein Aa Pada", hindiName: "चरणों में आ पड़ा...", author: "सुदर्शनजी", pgNum: 348),
        Book(name: "Nitya Piyo Dhi Dhari", hindiName: "नित्य पियो धी धारी...", author: "पं. दौलतरामजी", pgNum: 349),
        Book(name: "Sanchi To Ganga Yeh", hindiName: "सांची तो गंगा यह...", author: "पं. भागचन्दजी", pgNum: 349),
        Book(name: "Dhanya Dhanya Hai Ghadi Aaj Ki", hindiName: "धन्य धन्य है घड़ी आज की...", author: "पं. भागचन्दजी", pgNum: 350),
        Book(name: "Kevali-Karyo", hindiName: "केवली-कर्यों...", author: "ज्ञानानन्दजी", pgNum: 350),
        Book(name: "Dhanya Dhanya Jinwani Mata", hindiName: "धन्य-धन्य जिनवाणी माता...", author: "-", pgNum: 351),
        Book(name: "Dhanya-Dhanya Veetaragi Vani", hindiName: "धन्य-धन्य वीतरागी वाणी...", author: "-", pgNum: 352),
        Book(name: "Sumanak Vani Jinvar Ki Hamari", hindiName: "सुमनक वाणी जिनवर की हमारी...", author: "पं. बुधजन", pgNum: 352),
        Book(name: "Mukh Onkar Dhuni", hindiName: "मुख ओंकार धुनी...", author: "पं. बनारसीदास", pgNum: 352),
        Book(name: "Bhrat Jinwani Sam Nahi Aam", hindiName: "भ्रात जिनवाणी सम नहीं आम...", author: "नन्दलालजी", pgNum: 353),

        // Guru Bhakti
        Book(name: "Aise Sadhu Guru Kab Mile Hain", hindiName: "ऐसे साधु मुगुरु कब मिल हैं...", author: "पं. भागचन्दजी", pgNum: 354),
        Book(name: "Dhan-Dhan Jini Sadhu Jag Ke", hindiName: "धन-धन जनी साधु जग के...", author: "पं. भागचन्दजी", pgNum: 354),
        Book(name: "Param Guru Barasat Jnan Jhari", hindiName: "परम गुरु बरसत ज्ञान झरी...", author: "पं. घनतरायजी", pgNum: 354),
        Book(name: "Ve Muniwar Kab Mile Hain", hindiName: "वे मुनिवर कब मिले हैं...", author: "पं. भूधरदासजी", pgNum: 355),
        Book(name: "Aise Munivar Dekhe Van Mein", hindiName: "ऐसे मुनिवर देखे वन में...", author: "-", pgNum: 355),
        Book(name: "Param Digambar Muniwar", hindiName: "परम दिगंबर मुनिवर...", author: "-", pgNum: 355),

        // Various
        Book(name: "Ab Prabhu Charan Chhod Kya Jau", hindiName: "अब प्रभु चरण छोड़ क्यां जाऊँ...", author: "-", pgNum: 82),
        Book(name: "Prabhu Pai Yeh Varadan Supau", hindiName: "प्रभु पै यह वरदान सूपाऊँ...", author: "पं. भागचन्दजी", pgNum: 90),
        Book(name: "Ashareeri Siddha Bhagwan", hindiName: "अशरीरी सिद्ध भगवान...", author: "-", pgNum: 108),
        Book(name: "Mai Mahapunya Uday Se", hindiName: "मैं महापुण्य उदय से...", author: "-", pgNum: 115),
        Book(name: "Karo Jinvar Ka Gunagaan", hindiName: "करो जिनवर का गुणगान...", author: "-", pgNum: 133),
        Book(name: "Dekho Ji Adhishwar Swami", hindiName: "देखो जी आदिश्वर स्वामी...", author: "पं. दौलतरामजी", pgNum: 133),
        Book(name: "Shri Arihant Chhavi Likho", hindiName: "श्री अरिहंत छवि लिखो...", author: "जिनेंद्रदासजी", pgNum: 144),
        Book(name: "Rom-Rom Pulkit Ho Jaye", hindiName: "रोम-रोम पुलकित हो जाय...", author: "-", pgNum: 155),
        Book(name: "Chaitanya Vandana", hindiName: "चैतन्य वंदना", author: "-", pgNum: 163),
        Book(name: "Aaj Hum Jinaras", hindiName: "आज हम जिनारस...", author: "पंकजजी", pgNum: 174),
        Book(name: "Chaah Mujhe Hai Darshan Ki", hindiName: "चाह मुझे है दर्शन की...", author: "-", pgNum: 176),
        Book(name: "Jin Pratima Jinvar Si Chahiye", hindiName: "जिन प्रतिमा जिनवर-सी चाहिए...", author: "भैया भगवतीदासजी", pgNum: 188),
        Book(name: "Chakra Chalta Nahin", hindiName: "चक्का चलता नहीं...", author: "पं. भूधरदासजी", pgNum: 195),
        Book(name: "Nirakhat Jin Chandra Vadan", hindiName: "निरखत जिन चंद्र-वदन...", author: "पं. दौलतरामजी", pgNum: 214),
        Book(name: "Vandan Anup Chandra Kirti Jin", hindiName: "वंदन अनुप चंद्रकीर्ति जिन...", author: "पं. दौलतरामजी", pgNum: 219),
        Book(name: "He Jin Tera Sukh Ujagar", hindiName: "हे जिन तेरा सुख उजागर...", author: "पं. दौलतरामजी", pgNum: 224),
        Book(name: "Dashan Tumhara Mahar Hai", hindiName: "दशन तुम्हारा महार है...", author: "वृद्धिचंदजी", pgNum: 252),
        Book(name: "Nath Tumhari Pooja Mein Sab", hindiName: "नाथ तुम्हारी पूजा में सब...", author: "-", pgNum: 264),
        Book(name: "Daya Daan Pooja Sheel", hindiName: "दया दान पूजा शील...", author: "-", pgNum: 305),
        Book(name: "Aise Jinaraj Tahi Vandat Banarasi", hindiName: "ऐसे जिनराज ताहि वंदत बनारसी...", author: "पं. बनारसीदासजी", pgNum: 315),
        Book(name: "Shri Siddhachakra Mahatmaya", hindiName: "श्री सिद्धचक्र माहात्म्य...", author: "पं. रतनचंदजी", pgNum: 327),
        Book(name: "Hame Bhi Bulwalo Swami Siddho", hindiName: "हमको भी बुलवालो स्वामी सिद्धों...", author: "-", pgNum: 345)
    ]
]

