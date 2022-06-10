class PaiementSalaireModel {
  late int? id;
  late String nom;
  late String postNom;
  late String prenom;
  late String telephone;
  late String adresse;
  late String departement;
  late String numeroSecuriteSociale;
  late String matricule;
  late String servicesAffectation;
  late String salaire;
  late bool observation; // Payé ou non Payé  // pour Finance
  late String modePaiement; // mode depayement
  late DateTime createdAt; 
  late String tauxJourHeureMoisSalaire;
  late String joursHeuresPayeA100PourecentSalaire;
  late String totalDuSalaire;
  late String nombreHeureSupplementaires;
  late String tauxHeureSupplementaires;
  late String totalDuHeureSupplementaires;
  late String supplementTravailSamediDimancheJoursFerie;
  late String prime;
  late String divers;
  late String joursCongesPaye;
  late String tauxCongesPaye;
  late String totalDuCongePaye;
  late String jourPayeMaladieAccident;
  late String tauxJournalierMaladieAccident;
  late String totalDuMaladieAccident;
  late String pensionDeduction;
  late String indemniteCompensatricesDeduction;
  late String avancesDeduction;
  late String diversDeduction;
  late String retenuesFiscalesDeduction;
  late String nombreEnfantBeneficaireAllocationsFamiliales;
  late String nombreDeJoursAllocationsFamiliales;
  late String tauxJoursAllocationsFamiliales;
  late String totalAPayerAllocationsFamiliales;
  late String netAPayer;
  late String montantPrisConsiderationCalculCotisationsINSS;
  late String totalDuBrut;

  late String signature; // celui qui fait ce document


  PaiementSalaireModel({
    this.id,
    required this.nom,
    required this.postNom,
    required this.prenom,
    required this.telephone,
    required this.adresse,
    required this.departement,
    required this.numeroSecuriteSociale,
    required this.matricule,
    required this.servicesAffectation,
    required this.salaire,
    required this.observation,
    required this.modePaiement,
    required this.createdAt, 
    required this.tauxJourHeureMoisSalaire,
    required this.joursHeuresPayeA100PourecentSalaire,
    required this.totalDuSalaire,
    required this.nombreHeureSupplementaires,
    required this.tauxHeureSupplementaires,
    required this.totalDuHeureSupplementaires,
    required this.supplementTravailSamediDimancheJoursFerie,
    required this.prime,
    required this.divers,
    required this.joursCongesPaye,
    required this.tauxCongesPaye,
    required this.totalDuCongePaye,
    required this.jourPayeMaladieAccident,
    required this.tauxJournalierMaladieAccident,
    required this.totalDuMaladieAccident,
    required this.pensionDeduction,
    required this.indemniteCompensatricesDeduction,
    required this.avancesDeduction,
    required this.diversDeduction,
    required this.retenuesFiscalesDeduction,
    required this.nombreEnfantBeneficaireAllocationsFamiliales,
    required this.nombreDeJoursAllocationsFamiliales,
    required this.tauxJoursAllocationsFamiliales,
    required this.totalAPayerAllocationsFamiliales,
    required this.netAPayer,
    required this.montantPrisConsiderationCalculCotisationsINSS,
    required this.totalDuBrut,
    required this.signature

  });

  factory PaiementSalaireModel.fromSQL(List<dynamic> row) {
    return PaiementSalaireModel(
        id: row[0],
        nom: row[1],
        postNom: row[2],
        prenom: row[3],
        telephone: row[4],
        adresse: row[5],
        departement: row[6],
        numeroSecuriteSociale: row[7],
        matricule: row[8],
        servicesAffectation: row[9],
        salaire: row[10],
        observation: row[11],
        modePaiement: row[12],
        createdAt: row[13], 
        tauxJourHeureMoisSalaire: row[14],
        joursHeuresPayeA100PourecentSalaire: row[15],
        totalDuSalaire: row[16],
        nombreHeureSupplementaires: row[17],
        tauxHeureSupplementaires: row[18],
        totalDuHeureSupplementaires: row[19],
        supplementTravailSamediDimancheJoursFerie: row[20],
        prime: row[21],
        divers: row[22],
        joursCongesPaye: row[23],
        tauxCongesPaye: row[24],
        totalDuCongePaye: row[25],
        jourPayeMaladieAccident: row[26],
        tauxJournalierMaladieAccident: row[27],
        totalDuMaladieAccident: row[28],
        pensionDeduction: row[29],
        indemniteCompensatricesDeduction: row[30],
        avancesDeduction: row[31],
        diversDeduction: row[32],
        retenuesFiscalesDeduction: row[33],
        nombreEnfantBeneficaireAllocationsFamiliales: row[34],
        nombreDeJoursAllocationsFamiliales: row[35],
        tauxJoursAllocationsFamiliales: row[36],
        totalAPayerAllocationsFamiliales: row[37],
        netAPayer: row[38],
        montantPrisConsiderationCalculCotisationsINSS: row[39],
        totalDuBrut: row[40],
        signature: row[41]
    );
  }

  factory PaiementSalaireModel.fromJson(Map<String, dynamic> json) {
    return PaiementSalaireModel(
        id: json['id'],
        nom: json['nom'],
        postNom: json['postNom'],
        prenom: json['prenom'],
        telephone: json['telephone'],
        adresse: json['adresse'],
        departement: json['departement'],
        numeroSecuriteSociale: json['numeroSecuriteSociale'],
        matricule: json['matricule'],
        servicesAffectation: json['servicesAffectation'],
        salaire: json['salaire'],
        observation: bool.hasEnvironment(json['observation']),
        modePaiement: json['modePaiement'],
        createdAt: DateTime.parse(json['createdAt']),
        tauxJourHeureMoisSalaire: json['tauxJourHeureMoisSalaire'],
        joursHeuresPayeA100PourecentSalaire: json['joursHeuresPayeA100PourecentSalaire'],
        totalDuSalaire: json['totalDuSalaire'],
        nombreHeureSupplementaires: json['nombreHeureSupplementaires'],
        tauxHeureSupplementaires: json['tauxHeureSupplementaires'],
        totalDuHeureSupplementaires: json['totalDuHeureSupplementaires'],
        supplementTravailSamediDimancheJoursFerie:
            json['supplementTravailSamediDimancheJoursFerie'],
        prime: json['prime'],
        divers: json['divers'],
        joursCongesPaye: json['joursCongesPaye'],
        tauxCongesPaye: json['tauxCongesPaye'],
        totalDuCongePaye: json['totalDuCongePaye'],
        jourPayeMaladieAccident: json['jourPayeMaladieAccident'],
        tauxJournalierMaladieAccident: json['tauxJournalierMaladieAccident'],
        totalDuMaladieAccident: json['totalDuMaladieAccident'],
        pensionDeduction: json['pensionDeduction'],
        indemniteCompensatricesDeduction:
            json['indemniteCompensatricesDeduction'],
        avancesDeduction: json['avancesDeduction'],
        diversDeduction: json['diversDeduction'],
        retenuesFiscalesDeduction: json['retenuesFiscalesDeduction'],
        nombreEnfantBeneficaireAllocationsFamiliales:
            json['nombreEnfantBeneficaireAllocationsFamiliales'],
        nombreDeJoursAllocationsFamiliales:
            json['nombreDeJoursAllocationsFamiliales'],
        tauxJoursAllocationsFamiliales: json['tauxJoursAllocationsFamiliales'],
        totalAPayerAllocationsFamiliales:
            json['totalAPayerAllocationsFamiliales'],
        netAPayer: json['netAPayer'],
        montantPrisConsiderationCalculCotisationsINSS:
            json['montantPrisConsiderationCalculCotisationsINSS'],
        totalDuBrut: json['totalDuBrut'],
        signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'postNom': postNom,
      'prenom': prenom,
      'telephone': telephone,
      'adresse': adresse,
      'departement': departement,
      'numeroSecuriteSociale': numeroSecuriteSociale,
      'matricule': matricule,
      'servicesAffectation': servicesAffectation,
      'salaire': salaire,
      'observation': observation.toString(),
      'modePaiement': modePaiement,
      'createdAt': createdAt.toIso8601String(),
      'tauxJourHeureMoisSalaire': tauxJourHeureMoisSalaire,
      'joursHeuresPayeA100PourecentSalaire':
          joursHeuresPayeA100PourecentSalaire,
      'totalDuSalaire': totalDuSalaire,
      'nombreHeureSupplementaires': nombreHeureSupplementaires,
      'tauxHeureSupplementaires': tauxHeureSupplementaires,
      'totalDuHeureSupplementaires': totalDuHeureSupplementaires,
      'supplementTravailSamediDimancheJoursFerie':
          supplementTravailSamediDimancheJoursFerie,
      'prime': prime,
      'divers': divers,
      'joursCongesPaye': joursCongesPaye,
      'tauxCongesPaye': tauxCongesPaye,
      'totalDuCongePaye': totalDuCongePaye,
      'jourPayeMaladieAccident': jourPayeMaladieAccident,
      'tauxJournalierMaladieAccident': tauxJournalierMaladieAccident,
      'totalDuMaladieAccident': totalDuMaladieAccident,
      'pensionDeduction': pensionDeduction,
      'indemniteCompensatricesDeduction': indemniteCompensatricesDeduction,
      'avancesDeduction': avancesDeduction,
      'diversDeduction': diversDeduction,
      'retenuesFiscalesDeduction': retenuesFiscalesDeduction,
      'nombreEnfantBeneficaireAllocationsFamiliales':
          nombreEnfantBeneficaireAllocationsFamiliales,
      'nombreDeJoursAllocationsFamiliales': nombreDeJoursAllocationsFamiliales,
      'tauxJoursAllocationsFamiliales': tauxJoursAllocationsFamiliales,
      'totalAPayerAllocationsFamiliales': totalAPayerAllocationsFamiliales,
      'netAPayer': netAPayer,
      'montantPrisConsiderationCalculCotisationsINSS':
          montantPrisConsiderationCalculCotisationsINSS,
      'totalDuBrut': totalDuBrut,
      'signature': signature,
    };
  }
}
