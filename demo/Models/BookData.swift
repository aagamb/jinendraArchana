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
    
    // Custom hash and equality to compare books by content, not UUID
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(hindiName)
        hasher.combine(author)
        hasher.combine(pgNum)
    }
    
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.name == rhs.name &&
               lhs.hindiName == rhs.hindiName &&
               lhs.author == rhs.author &&
               lhs.pgNum == rhs.pgNum
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
       Book(name: "Pooja Pithika Sanskrit", hindiName: "पूजा पीठिका (संस्कृत)", author: "-", pgNum: 71),
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
       Book(name: "Videh Kshetra Stit Vidyaman 20 Tirthankar", hindiName: "विदेशक्षेत्र स्थित विद्धमान बीस तीर्थंकर पूजन", author: "पंडित घनतरायजी", pgNum: 113),
       Book(name: "24 Tirthankar Poojan", hindiName: "चौबीस तीर्थंकर पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 116),
       Book(name: "Vartaman Chaubisi Poojan", hindiName: "श्री वर्तमान चौबीसी पूजन", author: "कविवर वृष्टिदासदासजी", pgNum: 121),
       Book(name: "Seemandhar Poojan", hindiName: "समयिक पूजन", author: "डॉ. हुकमचंद भारिल्ल", pgNum: 124),
       Book(name: "Dashlakshan Poojan", hindiName: "दशलक्षण धर्म पूजन", author: "पंडित घनतरायजी", pgNum: 129),
       Book(name: "Samyak Ratnattray Poojan", hindiName: "सम्यक्तत्व धर्म पूजन", author: "पंडित घनतरायजी", pgNum: 132),
       Book(name: "Solahkaran Poojan", hindiName: "सोलहकारण पूजन", author: "पंडित घनतरायजी", pgNum: 134),
       Book(name: "Panchmeru Poojan", hindiName: "पंचमे पूजन", author: "पंडित घनतरायजी", pgNum: 135),
        Book(name: "Nandishwardweep Poojan", hindiName: "नन्दीश्वरद्वीप पूजन", author: "पंडित घनतरायजी", pgNum: 148),
            Book(name: "Adinath Jinpoojan", hindiName: "श्री आदिनाथ जिनपूजन", author: "पंडित जिनेन्द्रदासजी", pgNum: 152),
            Book(name: "Adinath Jinpoojan 2", hindiName: "श्री आदिनाथ जिनपूजन", author: "डॉ. अखिल बंसल", pgNum: 156),
            Book(name: "Chandraprabh Poojan", hindiName: "श्री चन्द्रप्रभ जिनपूजन", author: "पंडित वृन्दावनदासजी", pgNum: 159),
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
            Book(name: "Saptarshi Poojan", hindiName: "श्री संक्रांति पूजन", author: "पंडित रंगलालजी", pgNum: 205),
            Book(name: "Saraswati Poojan", hindiName: "सरस्वती पूजन", author: "पंडित घनतरायजी", pgNum: 208),
            Book(name: "Akshay Tritiya Poojan", hindiName: "अक्षय तृतीया पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 219),
            Book(name: "Rakshabandhan Parva Poojan", hindiName: "रक्षाबंधन पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 221),
            Book(name: "Veerashasan Jayanti Parva Poojan", hindiName: "वीराशासन जयंती पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 220),
            Book(name: "Kshamavani Poojan", hindiName: "क्षमावाणी पूजन", author: "श्री राजमलजी पचेया", pgNum: 224),
            Book(name: "Deepmala Parva Poojan", hindiName: "दीपमालिका पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 230),
            Book(name: "Shrut Panchami Parva Poojan", hindiName: "श्रुतपंचमी पर्व पूजन", author: "श्री राजमलजी पचेया", pgNum: 235),
            Book(name: "Nirvana Kshetra Poojan", hindiName: "निर्वाणक्षेत्र पूजन", author: "पंडित घनतरायजी", pgNum: 239),
            Book(name: "Nirvankand Bhasha", hindiName: "निर्वाण काण्ड भाषा", author: "भैया भगवतीदासजी", pgNum: 242),
            Book(name: "Swayambhu Stotra", hindiName: "स्वयम्भू-स्तोत्र (भाषा)", author: "श्री घनतरायजी", pgNum: 245),
            Book(name: "Chaturvish Tirthankar Ke Artha", hindiName: "चौबीस तीर्थंकरों के अर्थ", author: "-", pgNum: 246),
            Book(name: "Kootnim - Akritrim Chaityalayon Ke Artha", hindiName: "कूटनिम-अकृतिम चैत्यालयों के अर्थ", author: "-", pgNum: 252),
            Book(name: "Arghyavali", hindiName: "आचार्यावली", author: "-", pgNum: 254),
            Book(name: "Mahaarghya", hindiName: "mahaarghya", author: "-", pgNum: 259),
            Book(name: "Mahaarghya 2", hindiName: "mahaarghya", author: "-", pgNum: 260),
            Book(name: "Shanti Path (Sanskrit)", hindiName: "शांति पाठ (संस्कृत)", author: "-", pgNum: 261),
            Book(name: "Shanti Path (Bhasha)", hindiName: "शांति पाठ (भाषा)", author: "-", pgNum: 263),
            Book(name: "Visarjan", hindiName: "Visarjan", author: "-", pgNum: 264),
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
        Book(name: "Mahavirashtak Stotra", hindiName: "महावीराष्टक स्तोत्र", author: "कविवर भागचन्द", pgNum: 316),
        Book(name: "Mangalacharan", hindiName: "मंगलाचरण", author: "-", pgNum: 317),
        Book(name: "Samadhimaran (Hindi)", hindiName: "समाधिमरण (हिन्दी)", author: "पंडित सूरचन्दजी", pgNum: 319),
        Book(name: "Barah Bhavna", hindiName: "बारह भावना", author: "पंडित जयचन्दजी छाबड़ा", pgNum: 328),
        Book(name: "Barah Bhavna 2", hindiName: "बारह भावना", author: "पंडित भूधरदासजी", pgNum: 329),
        Book(name: "Tattvarth Sutra", hindiName: "तत्त्वार्थ सूत्र", author: "आचार्य उमास्वामी", pgNum: 330),

        ],
    "Bhakti": [
        Book(name: "Ab Prabhu Charan Chhod Kin Jaaun", hindiName: "अब प्रभु चरण छोड़ किन जाऊँ...", author: "-", pgNum: 82),
        Book(name: "Prabhu Pe Yah Vardan Supau", hindiName: "प्रभु पे यह वरदान सुपाऊँ...", author: "-", pgNum: 90),
        Book(name: "Ashariri Siddh Bhagwan", hindiName: "अशरीरी सिद्ध भगवान...", author: "-", pgNum: 108),
        Book(name: "Mein Mahapunya Uday Se", hindiName: "मैं महापुण्य उदय से...", author: "-", pgNum: 115),
        Book(name: "Karlo Jinvar Ka Gungan", hindiName: "कर लो जिनवर का गुणगान...", author: "-", pgNum: 123),
        Book(name: "Dekho Ji Aadishwar Swami", hindiName: "देखो जी आदिश्वर स्वामी...", author: "-", pgNum: 133),
        Book(name: "Shri Arihant Chhavi Lakhi", hindiName: "श्री अरिहंत छवि लिखी...", author: "-", pgNum: 141),
        Book(name: "Rom Rom Pulkit Ho Jaye", hindiName: "रोम-रोम पुलकित हो जाए...", author: "-", pgNum: 151),
        Book(name: "Chaitanya Vandana", hindiName: "चैतन्य वंदना...", author: "-", pgNum: 163),
        Book(name: "Aaj Hum Jinraj", hindiName: "आज हम जिनराज...", author: "-", pgNum: 171),
        Book(name: "Chaah Mujhe Hai Darshan Ki", hindiName: "चाह मुझे है दर्शन की...", author: "-", pgNum: 176),
        Book(name: "Jin Pratima Jinvar Si Kahiye", hindiName: "जिन प्रतिमा जिनवर सी कहिए...", author: "-", pgNum: 188),
        Book(name: "Charka Chalta Naahi", hindiName: "चरखा चलता नाही...", author: "-", pgNum: 195),
        Book(name: "Nirkhat Jin Chandra Badan", hindiName: "निरखत जिन चंद्र-बदन...", author: "-", pgNum: 214),
        Book(name: "Vando Adbhut Chandrveer Jin", hindiName: "वंदो अद्भुत चंद्रवीर जिन...", author: "-", pgNum: 229),
        Book(name: "He Jin Tero Sujas Ujagar", hindiName: "हे जिन तेरो सुजस उजागर...", author: "-", pgNum: 241),
        Book(name: "Darbaar Tumhara Manhar Hai", hindiName: "दरबार तुम्हारा मनहर है...", author: "-", pgNum: 252),
        Book(name: "Naath Tumhari Pooja Mein Sab", hindiName: "नाथ तुम्हारी पूजा में सब...", author: "-", pgNum: 264),
        Book(name: "Daya Daan Pooja Sheel", hindiName: "दया दान पूजा शील...", author: "-", pgNum: 305),
        Book(name: "Aise Jinraaj Taahi Vandat Banarsi", hindiName: "ऐसे जिनराज ताही वंदत बनारसी...", author: "-", pgNum: 315),
        Book(name: "Shri Siddhachakra Mahatmya", hindiName: "श्री सिद्धचक्र माहात्म्य...", author: "-", pgNum: 327),
        Book(name: "Hamko Bhi Bulvalo Swami", hindiName: "हमको भी बुलवालो स्वामी...", author: "-", pgNum: 341),
        // Bhakti Khand (Dev Bhakti)
        
        Book(name:"Ek Tumhi Hi Aadhar Ho Jagat", hindiName:"एक तुम्हीं आधार हो जग में...", author:"सौभाग्यमलजी", pgNum:342),
        Book(name:"Tihare Dhyaan Ki Moorat", hindiName:"तिहारे ध्यान की मूरत...", author:"-", pgNum:342),
        Book(name:"Mere Man Mandir Mein Aan", hindiName:"मेरे मन मंदिर में आना...", author:"-", pgNum:343),
        Book(name:"Nirkho Ang Ang Jinvar Ke", hindiName:"निरखो अंग-अंग जिनवर...", author:"-", pgNum:343),
        Book(name:"Aao Ji Man Mandir Mein Aao", hindiName:"आओ जी मन मंदिर में आओ...", author:"-", pgNum:344),
        Book(name:"Dhanya Dhanya Aaj Ghadi", hindiName:"धन्य धन्य आज घड़ी कैसी सुखकार है...", author:"सौभाग्यमलजी", pgNum:345),
        Book(name:"Veer Prabhu Ke Yeh Bol", hindiName:"वीर प्रभु के ये बोल तेरा प्रभु...", author:"-", pgNum:345),
        Book(name:"Hai Jinvani Mata", hindiName:"है जिनवाणी माता तुमको लाखों...", author:"शिवरामजी", pgNum:346),
        Book(name:"Jinvar Charan Bhakti Var Ganga", hindiName:"जिनवर चरण भक्ति वर गंगा...", author:"मानिकचंदजी", pgNum:347),
        Book(name:"Jinvani Mata Ratnattray", hindiName:"जिनवाणी माता रत्नत्रय...", author:"जयकुमारजी", pgNum:347),
        Book(name:"Jin Bain Sunat Mori", hindiName:"जिन-बैण सुनत मोरी भूल...", author:"पं. दौलतरामजी", pgNum:348),
        Book(name:"Jinvani Mata Darshan Tere", hindiName:"जिनवाणी माता दर्शन की...", author:"-", pgNum:348),
        Book(name:"Mahima Hai Agam Jinaagam ki", hindiName:"महिमा है अगम जिनागम की...", author:"पं. भागचन्दजी", pgNum:349),
        Book(name:"Charno Mein Aa Pada Hun", hindiName:"चरणों में आ पड़ो...", author:"सुदर्शनजी", pgNum:349),
        Book(name:"Nit Peejyo Dhi Dhaari", hindiName:"नित पीज्यो धीधारी...", author:"पं. दौलतरामजी", pgNum:349),
        Book(name:"Saanchi Toh Ganga", hindiName:"सांची तो गंगा यह...", author:"पं. भागचन्दजी", pgNum:349),
        Book(name:"Dhanya Dhanya Hai Ghadi Aaj Ki", hindiName:"धन्य धन्य है घड़ी आज की...", author:"पं. भागचन्दजी", pgNum:350),
        Book(name:"Kevali Kanye", hindiName:"केवलि-कन्ये...", author:"ज्ञानानन्दजी", pgNum:350),
        Book(name:"Dhanya Dhanya Jinvani Mata", hindiName:"धन्य-धन्य जिनवाणी माता...", author:"-", pgNum:351),
        Book(name:"Dhanya Dhanya Veetrag Vani", hindiName:"धन्य-धन्य वीतराग वाणी...", author:"-", pgNum:351),
        Book(name:"Sunkar Vani Jinvar Ki", hindiName:"सुनकर वाणी जिनवर की स्वर...", author:"पं. बुधजन", pgNum:352),
        Book(name:"Mukh Omkar Suni", hindiName:"मुख ओंकार धुनि...", author:"पं. बनारसीदास", pgNum:352),
        Book(name:"Jinadesh Gyata", hindiName:"श्राव जिनवाणी सम नहीं आन...", author:"नन्दलालजी", pgNum:353),
        Book(name:"Ve Munivar Kab Mili Hai Upgari", hindiName:"ऐसे साधु सुमर कब मिलें हैं...", author:"पं. भागचन्दजी", pgNum:354),
        Book(name:"Dhanya Jaini Sadhu Jagat Ke", hindiName:"धन्य-धन्य जैनि साधु जगत के...", author:"पं. भागचन्दजी", pgNum:354),
        Book(name:"Param Guru Barsat Gyaan Jhari", hindiName:"परम गुरु बरसत ज्ञान झरी...", author:"पं. घ्यानतरायजी", pgNum:357),
        Book(name:"Ve Munivar Kab Mili Hai", hindiName:"वे मुनिवर कब मिले हैं...", author:"पं. भूधरदासजी", pgNum:357),
        Book(name:"Param Digambar Munivar Dekhe", hindiName:"ऐसे मुनिवर देखे वन में...", author:"-", pgNum:355),
        Book(name:"Sant Sadhu Ban Ke Vichru", hindiName:"संत साधु बन के विचरूं...", author:"-", pgNum:356),
        Book(name:"Dhanya Munishwar Aatam Hit", hindiName:"धन्य मुनिश्वर आतम हित में...", author:"-", pgNum:356),
        Book(name:"Mhara Param Digambar Munivar Aaya", hindiName:"म्हारा परम दिगम्बर मुनिवर आया...", author:"सौभाग्यमलजी", pgNum:357),
        Book(name:"He Param Digambar Sadhu Ke", hindiName:"हे परम दिगम्बर साधु के...", author:"सौभाग्यमलजी", pgNum:358),
        Book(name:"Nit Uth Dhyau", hindiName:"नित उठ ध्यानूँ, गुण गाऊँ...", author:"सौभाग्यमलजी", pgNum:358),
        Book(name:"He Param Digambar Yati", hindiName:"हे परम दिगम्बर यति महागुण...", author:"सौभाग्यमलजी", pgNum:359),
        Book(name:"He Param Digambar Mudra Jinki", hindiName:"हे परम दिगम्बर मुद्रा जिनकी...", author:"पं. अभयकुमारजी", pgNum:359),
        Book(name:"Holi Khele Muniraj Shikhar Van Mein", hindiName:"होली खेलें मुनिराज शिखर वन में...", author:"पं. भूधरदासजी", pgNum:360)
    ]
]
    
