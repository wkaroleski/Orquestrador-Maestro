from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase import pdfmetrics

OUT = 'output/pdf/analise-fluxo-matt-pocock-orquestrador-maestro.pdf'

try:
    pdfmetrics.registerFont(TTFont('Aptos', 'C:/Windows/Fonts/aptos.ttf'))
    pdfmetrics.registerFont(TTFont('Aptos-Bold', 'C:/Windows/Fonts/aptosbd.ttf'))
    FONT, BOLD = 'Aptos', 'Aptos-Bold'
except Exception:
    FONT, BOLD = 'Helvetica', 'Helvetica-Bold'

navy = colors.HexColor('#102A43')
blue = colors.HexColor('#2563EB')
teal = colors.HexColor('#0F766E')
ink = colors.HexColor('#243B53')
muted = colors.HexColor('#627D98')
light = colors.HexColor('#F0F4F8')
gold = colors.HexColor('#F59E0B')

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='CoverTitle', fontName=BOLD, fontSize=27, leading=32, textColor=navy, spaceAfter=12))
styles.add(ParagraphStyle(name='CoverSub', fontName=FONT, fontSize=13, leading=19, textColor=muted))
styles.add(ParagraphStyle(name='H1x', fontName=BOLD, fontSize=18, leading=23, textColor=navy, spaceBefore=8, spaceAfter=10))
styles.add(ParagraphStyle(name='H2x', fontName=BOLD, fontSize=12.5, leading=16, textColor=teal, spaceBefore=9, spaceAfter=5))
styles.add(ParagraphStyle(name='Bodyx', fontName=FONT, fontSize=9.8, leading=14.2, textColor=ink, spaceAfter=6))
styles.add(ParagraphStyle(name='Smallx', fontName=FONT, fontSize=8, leading=11, textColor=muted))
styles.add(ParagraphStyle(name='Callout', fontName=FONT, fontSize=10, leading=14, textColor=navy, backColor=colors.HexColor('#E8F1FF'), borderColor=blue, borderWidth=0.7, borderPadding=9, spaceBefore=6, spaceAfter=10))
styles.add(ParagraphStyle(name='Cell', fontName=FONT, fontSize=8.2, leading=11, textColor=ink))
styles.add(ParagraphStyle(name='CellHead', fontName=BOLD, fontSize=8.4, leading=11, textColor=colors.white))

def P(text, style='Bodyx'):
    return Paragraph(text, styles[style])

def header_footer(canvas, doc):
    canvas.saveState()
    w, h = A4
    canvas.setStrokeColor(colors.HexColor('#D9E2EC'))
    canvas.line(18*mm, 14*mm, w-18*mm, 14*mm)
    canvas.setFont(FONT, 7.5)
    canvas.setFillColor(muted)
    canvas.drawString(18*mm, 9*mm, 'Orquestrador-Maestro | Análise de fluxo de desenvolvimento assistido por IA')
    canvas.drawRightString(w-18*mm, 9*mm, f'{doc.page}')
    canvas.restoreState()

def table(data, widths):
    t = Table(data, colWidths=widths, repeatRows=1, hAlign='LEFT')
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), navy), ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('FONTNAME', (0,0), (-1,0), BOLD), ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('GRID', (0,0), (-1,-1), 0.35, colors.HexColor('#D9E2EC')),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, light]),
        ('LEFTPADDING', (0,0), (-1,-1), 7), ('RIGHTPADDING', (0,0), (-1,-1), 7),
        ('TOPPADDING', (0,0), (-1,-1), 6), ('BOTTOMPADDING', (0,0), (-1,-1), 6),
    ]))
    return t

story = []
story += [Spacer(1, 27*mm), P('Remodelagem do fluxo de desenvolvimento com IA', 'CoverTitle'), P('Análise do método de Matt Pocock e proposta de adaptação para o Orquestrador-Maestro', 'CoverSub'), Spacer(1, 15*mm)]
story += [P('<b>Resumo executivo</b><br/>O método de Matt Pocock oferece uma disciplina forte para transformar ideias vagas em mudanças implementáveis, verificáveis e revisáveis. A melhor adaptação para o Orquestrador-Maestro é combinar fases controladas pelo maestro com slices verticais executáveis, mantendo gates humanos entre decisões importantes.', 'Callout')]
story += [Spacer(1, 38*mm), P('Documento de recomendação', 'Smallx'), P('19 de julho de 2026', 'Smallx'), PageBreak()]

story += [P('1. O que foi pesquisado', 'H1x'), P('A pesquisa foi baseada no repositório público de skills do Matt Pocock, nos materiais do AI Hero e em resumos do workshop sobre fluxo de desenvolvimento com agentes. O núcleo do método é composto por alinhamento, especificação, decomposição, implementação incremental e revisão independente.'),
          P('O fluxo clássico pode ser resumido como:', 'Bodyx'), P('<b>grill-with-docs → to-prd → to-issues → tdd/implement → review</b>', 'Callout'),
          P('O método também inclui ferramentas complementares para prototipagem, diagnóstico, handoff, análise arquitetural e melhoria contínua. A mensagem recebida pelo usuário mistura esse fluxo com uma adaptação em fases, mais adequada para avaliação humana progressiva.'),
          P('2. Principais ideias aproveitáveis', 'H1x')]
rows = [[P('Ideia', 'CellHead'), P('Valor', 'CellHead'), P('Adaptação recomendada', 'CellHead')],
        [P('Alinhamento rigoroso', 'Cell'), P('Reduz interpretações erradas antes do código.', 'Cell'), P('Criar uma entrevista limitada, baseada no código e na documentação.', 'Cell')],
        [P('PRD como destino', 'Cell'), P('Mantém problema, decisões e critérios de aceite explícitos.', 'Cell'), P('Usar <b>DEV/SPECS/</b> como fonte de verdade local.', 'Cell')],
        [P('Slices verticais', 'Cell'), P('Entrega feedback integrado cedo.', 'Cell'), P('Usar slices dentro das fases, atravessando banco, domínio, API, UI e testes.', 'Cell')],
        [P('Execução AFK', 'Cell'), P('Automatiza tarefas bem especificadas.', 'Cell'), P('Permitir apenas em itens classificados como AFK e com limites de execução.', 'Cell')],
        [P('Revisão em contexto novo', 'Cell'), P('Evita que o próprio agente valide seus pressupostos.', 'Cell'), P('Separar implementação, revisão técnica e aprovação humana.', 'Cell')]]
story += [table(rows, [42*mm, 57*mm, 73*mm]), PageBreak()]

story += [P('3. Modelo recomendado para o Orquestrador-Maestro', 'H1x'), P('A proposta não é substituir as capacidades existentes, mas conectá-las em um fluxo único e explícito:'), P('<b>Ideia → Contexto → PRD → Fases → Slices → Implementação → Verificação → Revisão → Retrospectiva</b>', 'Callout'),
          P('3.1 Fases e slices', 'H2x'), P('Fases organizam arquitetura, dependências, riscos e decisões. Slices verticais organizam a execução. Uma fase pode conter diversos slices, e cada slice precisa produzir algo demonstrável ou verificável por conta própria.'),
          P('Exemplo de decomposição:', 'Bodyx')]
rows = [[P('Fase', 'CellHead'), P('Slices possíveis', 'CellHead'), P('Gate humano', 'CellHead')],
        [P('Fundamentos', 'Cell'), P('modelo mínimo; migração; serviço; API mínima; tela integrada', 'Cell'), P('validar domínio, dados e contratos', 'Cell')],
        [P('Regras de negócio', 'Cell'), P('fluxo principal; permissões; erros; estados de exceção', 'Cell'), P('validar regras e casos-limite', 'Cell')],
        [P('Qualidade', 'Cell'), P('refatoração; segurança; UX; acessibilidade; observabilidade', 'Cell'), P('aprovar risco residual e comportamento final', 'Cell')]]
story += [table(rows, [36*mm, 83*mm, 53*mm]), P('3.2 Contrato de cada slice', 'H2x'), P('Cada slice deve declarar tipo <b>HITL</b> (human-in-the-loop) ou <b>AFK</b> (away-from-keyboard), dependências, camadas afetadas, critérios de aceite, testes e comando de verificação. Testes não devem virar uma etapa horizontal isolada; devem acompanhar a entrega do comportamento.'),
          P('3.3 Impacto arquitetural explícito', 'H2x'), P('O plano deve distinguir: <b>deve ser alterado</b>, <b>provavelmente será alterado</b>, <b>pode ser impactado</b> e <b>não deve ser tocado</b>. Essa distinção reduz mudanças acidentais e torna a revisão mais objetiva.'), PageBreak()]

story += [P('4. Skills e artefatos a agregar', 'H1x')]
items = [
('grill-with-docs', 'Entrevista baseada no repositório; atualiza CONTEXT.md e ADRs; não implementa automaticamente.'),
('to-prd', 'Converte o alinhamento em especificação com escopo, fora de escopo, regras, decisões, riscos, critérios de aceite e testes.'),
('prd-to-phases', 'Transforma a especificação em fases, dependências, impacto esperado e gates humanos.'),
('phase-to-slices', 'Gera slices verticais locais com tipo HITL/AFK, camadas, critérios de aceite e verificação.'),
('improve-codebase-architecture', 'Produz relatório visual de dependências, módulos rasos, riscos de mudança e oportunidades de aprofundamento.'),
('prototype', 'Valida interface, estados e decisões de produto antes de comprometer a implementação.'),
('review independente', 'Avalia fidelidade ao PRD, arquitetura, testes, segurança, UX e dívida técnica em contexto novo.'),
('retrospectiva', 'Converte erros recorrentes e decisões difíceis em documentação, checklists e melhorias de skills.')]
for name, desc in items:
    story += [KeepTogether([P(name, 'H2x'), P(desc)])]
story += [P('Estrutura sugerida:', 'H2x'), P('<b>DEV/CONTEXT.md</b> — vocabulário e contexto do domínio<br/><b>DEV/SPECS/</b> — PRDs e especificações ativas<br/><b>DEV/PHASES/</b> — planos aprovados por fase<br/><b>DEV/SLICES/</b> — unidades executáveis<br/><b>DEV/ADR/</b> — decisões arquiteturais<br/><b>DEV/REPORTS/</b> — relatórios visuais e revisões'), PageBreak()]

story += [P('5. Guardrails essenciais', 'H1x'), P('A adoção precisa preservar o controle do maestro e evitar que o processo se transforme em automação sem supervisão.'),
          P('Limitar a entrevista', 'H2x'), P('Usar um orçamento de perguntas, por exemplo 12 a 20 perguntas críticas, com encerramento quando a confiança estiver suficiente. A entrevista deve explorar o código quando a resposta puder ser descoberta localmente.'),
          P('Limitar o modo AFK', 'H2x'), P('Somente slices pequenos, com critérios de aceite objetivos, testes executáveis, escopo fechado e rollback simples. Nunca delegar decisões de arquitetura, segurança ou mudança de dados sem aprovação.'),
          P('Separar papéis', 'H2x'), P('O agente que implementa não deve ser a única fonte da revisão. A revisão deve ocorrer em contexto novo e a aprovação final de decisões importantes permanece humana.'),
          P('Evitar importação indiscriminada', 'H2x'), P('O valor está na composição disciplinada, não na quantidade de skills. O repositório já possui planner, architect, reviewer, Ralph, team, handoff e documentação DEV; a prioridade é roteá-los e conectá-los.'),
          P('6. Roteamento proposto', 'H1x')]
rows = [[P('Situação', 'CellHead'), P('Fluxo', 'CellHead')],
        [P('Ideia vaga', 'Cell'), P('grill-with-docs → to-prd', 'Cell')],
        [P('Feature grande', 'Cell'), P('to-prd → prd-to-phases → phase-to-slices', 'Cell')],
        [P('Fase aprovada', 'Cell'), P('tdd/implement → testes → review', 'Cell')],
        [P('Código confuso', 'Cell'), P('zoom-out → improve-codebase-architecture', 'Cell')],
        [P('Mudança visual', 'Cell'), P('prototype → design review → implementation', 'Cell')],
        [P('Bug ou regressão', 'Cell'), P('diagnose → reprodução → correção → teste de regressão', 'Cell')]]
story += [table(rows, [48*mm, 124*mm]), PageBreak()]

story += [P('7. Roadmap de implementação', 'H1x'), P('A remodelagem pode ser feita incrementalmente, sem interromper o fluxo atual.'),
          P('Prioridade 1 — Integração documental', 'H2x'), P('Definir os formatos de CONTEXT, PRD, fase e slice em DEV. Atualizar o roteador para reconhecer a sequência e manter gates humanos.'),
          P('Prioridade 2 — Fases e slices', 'H2x'), P('Criar as skills prd-to-phases e phase-to-slices, reutilizando planner, architect, team e Ralph quando adequado.'),
          P('Prioridade 3 — Contexto visual', 'H2x'), P('Adicionar relatório visual de arquitetura e impacto de mudanças; incluir protótipo para tarefas de interface.'),
          P('Prioridade 4 — Qualidade e aprendizagem', 'H2x'), P('Adicionar revisão independente, retrospectiva e métricas simples: tempo por fase, retrabalho, falhas encontradas na revisão e consumo de tokens.'),
          P('8. Conclusão', 'H1x'), P('O fluxo de Matt Pocock é uma boa referência porque transforma a interação com a IA em um processo de engenharia: primeiro alinhamento, depois especificação, decomposição, execução incremental e verificação. A adaptação em fases do Orquestrador-Maestro é ainda mais adequada ao objetivo de economizar tokens e permitir avaliação contínua.'), P('A recomendação é adotar um fluxo híbrido: <b>fases para governança e slices verticais para entrega</b>. Com isso, o sistema ganha previsibilidade, melhor feedback, menos contexto desperdiçado e maior clareza sobre o impacto de cada mudança.'),
          P('Referências consultadas', 'H2x'), P('1. <link href="https://github.com/mattpocock/skills" color="#2563EB">GitHub — mattpocock/skills</link><br/>2. <link href="https://www.aihero.dev/posts" color="#2563EB">AI Hero — AI Engineering Posts</link><br/>3. <link href="https://talksintel.ai/ai-ml/conferences/aie-eu-2026/full-walkthrough-workflow-for-ai-coding/" color="#2563EB">TalksIntel — Full Walkthrough: Workflow for AI Coding</link><br/>4. <link href="https://github.com/mattpocock/skills/issues/132" color="#2563EB">GitHub Issue #132 — limite de entrevistas</link><br/>5. <link href="https://github.com/mattpocock/skills/issues/134" color="#2563EB">GitHub Issue #134 — proteção contra implementação automática</link>', 'Smallx')]

doc = SimpleDocTemplate(OUT, pagesize=A4, rightMargin=18*mm, leftMargin=18*mm, topMargin=17*mm, bottomMargin=19*mm, title='Remodelagem do fluxo de desenvolvimento com IA')
doc.build(story, onFirstPage=header_footer, onLaterPages=header_footer)
print(OUT)
