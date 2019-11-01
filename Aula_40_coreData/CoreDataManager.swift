//
//  CoreDataManager.swift
//  Aula_40_coreData
//
//  Created by Marcela Limieri Tozzato on 30/10/19.
//  Copyright © 2019 Marcela Limieri Tozzato. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
//Cógido copiado do AppDelegate para acessar o banco de dados:
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Aula_40_coreData") //Passa o nome do banco de dados
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in //Tenta acessar
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)") //Se não conseguir da fatal error
            }
        })
        return container //Se conseguir retorna o banco de dados
    }()
    
//Função criada para salvar as informações:
    func saveInformation(name: String, passportNumber: String) {
        let context = persistentContainer.viewContext //basicamente estamos diminuindo o nome para trabalharmos com o banco de dados que criamos no método acima - é usual trabalhar com context
        
        //POPULANDO:
        let person = Person(context: context)
        person.name = name
        //person.passport?.number = passportNumber - apesar de person conseguir acessar passport, não devo fazer isso, pois passaporte é um objeto complexo, que contem várias propriedades além de number. Passport deve ser instanciado, populado, para depois ser acessado atraves de person.
        
        let passport = Passport(context: context)
        passport.number = passportNumber
        person.passport = passport //Agora que a ligação foi feita é possivel acessar o number atraves de pessoa.passport
        
        //SALVANDO:
        try? context.save()
    }

//Função criada para carregar a informação:
    func loadInformation(completion:([Person]) -> Void){
        //ACESSAR O BANCO DE DADOS ATRAVES DO NOME CONTEXT:
        let context = persistentContainer.viewContext
        //BUSCAR INFORMAÇÃO NO BANCO DE DADOS (REQUEST):
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person") //De onde você quer trazer a informação?! "Person"
        //EXECUTAR A REQUEST:
        let result = try? context.fetch(request) //o fetch acessa o Person, mas não tras do tipo person, tras do tipo genérico
        //CASTING PARA TRANFORMAR O RESULT EM PERSON:
        let arrayPerson = result as? [Person] ?? []
        //RETORNAR O OBJETO PARA QUEM CHAMOU:
        completion(arrayPerson)
    }

//Função para deletar informação:
    func deleteInformation(id: NSManagedObjectID, completion: (Bool) -> Void){ //Para acessarmos um item dentro do coreData precisamos de um ID
        //ACESSAR O BANCO DE DADOS ATRAVES DO NOME CONTEXT:
        let context = persistentContainer.viewContext
        //ACESSAR O OBJETO DENTRO DO BANCO:
        let obj = context.object(with: id)
        //DELETANTO O OBJETO:
        context.delete(obj)
        //SALVANDO:
        do{
            try context.save()
            completion (true)
        } catch {
            completion (false)
        }
        
        //o completion informa que terminou, desta forma a tabela poderá ser atualizada
        
    }

}

//lazy var: só cria a variavel quando for usar
//variavel computada: {} é possivel aplicar uma lógica de programação dentro da própria variável


