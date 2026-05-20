#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

console.log('🎼 Maestro Health Check v1.0');
console.log('----------------------------');

const filesToVerify = [
    'rules.md',
    'maestro.md',
    'hooks.md',
    'SKILLS_INDEX.md',
    'ecosistema.md'
];

let allOk = true;

filesToVerify.forEach(file => {
    const p = path.join(__dirname, '..', file);
    if (fs.existsSync(p)) {
        console.log(`✅ ${file} está presente.`);
    } else {
        console.log(`❌ ${file} está AUSENTE!`);
        allOk = false;
    }
});

const symlinkPath = '{{USER_HOME}}/.opencode';
if (fs.existsSync(symlinkPath)) {
    console.log(`✅ Link Simbólico (.opencode) está ativo.`);
} else {
    console.log(`❌ Link Simbólico (.opencode) está quebrado!`);
    allOk = false;
}

if (allOk) {
    console.log('\n✨ A Sinfonia está em harmonia total!');
} else {
    console.log('\n⚠️ Foram encontrados problemas na sincronia.');
}
