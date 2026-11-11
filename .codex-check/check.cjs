const fs=require('fs');
const {PGlite}=require('./pglite/package/dist/index.cjs');
(async()=>{
 const db=new PGlite();
 console.log((await db.query('SELECT version()')).rows[0]);
 await db.exec(fs.readFileSync('docs/soluciones/sql/gamehub-estructura.sql','utf8'));
 await db.exec(fs.readFileSync('docs/recursos/postgresql/sql/gamehub-datos.sql','utf8'));
 const {queries,view}=JSON.parse(fs.readFileSync('.codex-check/queries.json','utf8'));
 await db.exec(view);
 const results={};
 for(const [id,sql] of Object.entries(queries)){
   try {const r=await db.exec(sql); results[id]=r[r.length-1];}
   catch(e){console.error('ERROR ejercicio',id,e.message);throw e;}
 }
 fs.writeFileSync('.codex-check/results.json',JSON.stringify(results));
 console.log('Consultas verificadas:',Object.keys(results).length);
 await db.close();
 const mobile=new PGlite();
 await mobile.exec(fs.readFileSync('docs/soluciones/sql/mundomoviles-estructura.sql','utf8'));
 await mobile.exec(fs.readFileSync('docs/recursos/postgresql/sql/mundomoviles-datos.sql','utf8'));
 console.log('Móviles:',(await mobile.query('SELECT COUNT(*) FROM moviles')).rows[0]);
 await mobile.close();
})().catch(e=>{console.error(e.message);process.exitCode=1});
