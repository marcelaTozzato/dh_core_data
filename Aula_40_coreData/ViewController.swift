//
//  ViewController.swift
//  Aula_40_coreData
//
//  Created by Marcela Limieri Tozzato on 30/10/19.
//  Copyright © 2019 Marcela Limieri Tozzato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passportTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //INSTANCIANDO O COREDATA PARA PODERMOS ACESSAR AS FUNÇÕES:
    let coreDataManager = CoreDataManager()
    //CRIANDO UMA VAR PARA RECEBER A INFORMAÇÃO DO COREDATAMANAGER:
    var arrayPerson: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView() //Se não tiver dados a tableView vai carregar em branco 
        self.loadInformation() //preciso atualizar a table view ao carregar, pois posso ter informações prévias
    }

    //CARREGANDO AS INFORMAÇÕES DO COREDATA E ATUALIZANDO A TABLEVIEW:
    func loadInformation(){
        coreDataManager.loadInformation { (arrayPerson) in
            self.arrayPerson = arrayPerson
            self.tableView.reloadData()
        }
    }
    
    //SALVANDO AS INFORMAÇÕES NO COREDATA:
    @IBAction func clicouAdicionar(_ sender: UIButton) {
        coreDataManager.saveInformation(name: nameTextField.text ?? "", passportNumber: passportTextField.text ?? "")
        self.loadInformation() //Depois de salvar as informações eu carrego a informação e atualizo a tableView
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //Neste caso estamos usando uma célula padrão:
        cell.textLabel?.text = arrayPerson[indexPath.row].name
        cell.detailTextLabel?.text = arrayPerson[indexPath.row].passport?.number
        
        //Como a célula é padrão, não há casting
        return cell
    }
    
    //SWIPE PARA DELETAR:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.coreDataManager.deleteInformation(id: arrayPerson[indexPath.row].objectID ) { (sucess) in
            if sucess { loadInformation()}
        }
    }
}

//É um banco de dados
//Banco guarda dados, que são informaçoes brutas e por vezes nao fazem sentido sem um cotexto
//Chave primária - é uma chave que nao pode se repetir, é um identificador primário e tem preferencia sobre outras chaves - ex: CPF (Core Data é alto nivel, portanto nao trabalha com chave primária)
//Core Data é um framework nativo da Apple que se baseia no Sqlite
//Sempre que você quer trazer uma informação do banco de dados você faz um request (NSFetchRequest)
//NSPredicate - você vai fazer algumas restrições
//Entidade é uma tabela e podem ser entendidas como classes, e os atributos dentro delas como propriedades

