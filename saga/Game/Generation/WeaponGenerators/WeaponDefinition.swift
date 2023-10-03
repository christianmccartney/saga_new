//
//  WeaponDefinition.swift
//  saga
//
//  Created by Christian McCartney on 12/4/21.
//

struct WeaponDefinition {
    let type: WeaponType
    let componentForms: Set<WeaponComponentForm>
    let property: WeaponProperty
}

extension WeaponDefinition {
    static func randomSword() -> WeaponDefinition {
        let forms: [WeaponForm] = [.straight, .parabolic, .cubic, .wavy, .twopronged]
        let random = [WeaponComponentForm(component: .blade, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .crossguard, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .hilt, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .pommel, form: forms[Int.random(in: 0..<forms.count)])]
        return WeaponDefinition(
            type: .sword,
            componentForms: Set(random),
            property: .simple)
    }
    
    static func randomSpear() -> WeaponDefinition {
        let forms: [WeaponForm] = [.straight, .parabolic]//, .cubic, .wavy, .twopronged]
        let random = [WeaponComponentForm(component: .blade, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .crossguard, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .hilt, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .pommel, form: forms[Int.random(in: 0..<forms.count)])]
        return WeaponDefinition(
            type: .spear,
            componentForms: Set(random),
            property: .simple)
    }
}
