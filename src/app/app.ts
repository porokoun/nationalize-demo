import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import countries from 'i18n-iso-countries';
import enLocale from 'i18n-iso-countries/langs/en.json';

countries.registerLocale(enLocale); // register English country names

interface Person {
  no: number;
  name: string;
  age: number | null;
  nationality?: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  showTable = false;
  newName = '';
  newAge: number | null = null;

  people: Person[] = [
    { no: 1, name: 'Alex', age: 23 },
    { no: 2, name: 'Mia', age: 30 },
    { no: 3, name: 'Zayn', age: 28 },
    { no: 4, name: 'Nathaniel', age: 41 },
    { no: 5, name: 'Susan', age: 32 },
  ];

  constructor(private http: HttpClient) {}

  showData() {
    this.showTable = true;
    this.people.forEach(p => this.checkAndFetchNationality(p));
  }

  async checkAndFetchNationality(person: Person): Promise<void> {
    if (!person.age || person.age <= 30) {
      person.nationality = '-';
      return;
    }

    try {
      const res: any = await this.http
        .get(`https://api.nationalize.io/?name=${person.name}`)
        .toPromise();

      const top = res?.country?.[0];
      if (top) {
        const fullName = countries.getName(top.country_id, 'en');
        const percentage = (top.probability * 100).toFixed(1);
        person.nationality = `${fullName || top.country_id} (${percentage}%)`;
      } else {
        person.nationality = '-';
      }
    } catch {
      person.nationality = 'Error';
    }
  }

  async onAgeChange(person: Person): Promise<void> {
    await this.checkAndFetchNationality(person);
  }

  async addPerson(): Promise<void> {
    const trimmed = this.newName.trim();
    if (!trimmed || this.newAge === null || isNaN(this.newAge)) return;

    const newPerson: Person = {
      no: this.people.length + 1,
      name: trimmed,
      age: this.newAge,
      nationality: '-'
    };

    this.people.push(newPerson);
    await this.checkAndFetchNationality(newPerson);
    this.newName = '';
    this.newAge = null;
  }
  deletePerson(person: Person) {
    this.people = this.people.filter(p => p !== person);
    this.reindexNumbers();
  }

  reindexNumbers() {
    this.people.forEach((p, index) => {
      p.no = index + 1;
    });
  }
}
