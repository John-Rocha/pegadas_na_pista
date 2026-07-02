# PRD — Registro de Atropelamento e Avistamento de Fauna

**Projeto:** Pegadas na Pista  
**Módulo:** Aplicativo Mobile  
**Plataforma:** Flutter — Android e iOS  
**Backend:** API própria  
**Banco de Dados:** PostgreSQL + PostGIS  
**Storage de Imagens:** Storage próprio ou serviço compatível com S3  
**Versão:** 1.0  

---

## 1. Objetivo

Implementar no aplicativo mobile o fluxo de cadastro de ocorrências de fauna, permitindo que usuários autenticados registrem **atropelamentos** ou **avistamentos** de animais silvestres, informando espécie, fotos, data, hora, condições ambientais e localização georreferenciada capturada no momento do cadastro.

O registro deverá ser enviado para uma **API própria**, persistido em banco **PostgreSQL com PostGIS** e salvo com status inicial **pendente de validação**, permitindo análise posterior por pesquisadores, validadores ou administradores da plataforma.

---

## 2. Contexto

A plataforma Pegadas na Pista tem como objetivo apoiar ações de ciência cidadã, educação ambiental e monitoramento participativo de fauna em rodovias, especialmente na BR-156, no estado do Amapá.

O aplicativo mobile será utilizado por cidadãos, estudantes, pesquisadores e agentes envolvidos no monitoramento da fauna. O usuário poderá registrar ocorrências observadas em campo, contribuindo para a construção de uma base científica sobre atropelamentos e avistamentos de fauna silvestre.

---

## 3. Decisão Técnica Importante

O aplicativo **não utilizará Firebase**.

Portanto, os seguintes pontos devem ser tratados por infraestrutura própria ou serviços externos não Firebase:

| Necessidade | Solução recomendada |
|---|---|
| Autenticação | API própria com JWT/OAuth2 |
| Banco de dados | PostgreSQL + PostGIS |
| Upload de fotos | Storage próprio, MinIO, AWS S3, DigitalOcean Spaces ou equivalente |
| Consulta de espécies | Endpoint próprio da API |
| Registro de ocorrências | Endpoint REST próprio |
| Validação técnica | Painel web ou endpoint administrativo próprio |
| Logs e monitoramento | Sentry, Grafana, Loki, OpenTelemetry ou equivalente |

---

## 4. Escopo da Implementação

### 4.1. Dentro do escopo

- Login do usuário no app.
- Cadastro de registro de fauna.
- Escolha do tipo de registro:
  - Atropelamento;
  - Avistamento.
- Registro de espécie animal.
- Registro de data e hora da ocorrência.
- Captura automática de georreferência.
- Registro de condições ambientais.
- Upload de uma ou mais fotos.
- Envio do registro para API própria.
- Criação do registro com status inicial `pendente`.
- Persistência dos dados nas tabelas relacionadas.
- Validação básica de campos obrigatórios.
- Tratamento de permissão de localização, câmera e galeria.
- Exibição de feedback de sucesso ou erro ao usuário.

### 4.2. Fora do escopo inicial

- Validação científica avançada da espécie.
- Dashboard analítico.
- Cálculo automático de hotspots.
- Relatórios gerenciais.
- Gamificação.
- Modo offline completo.
- Notificações push.
- Integração automática com APIs climáticas externas.

---

## 5. Personas

### 5.1. Usuário comum

Pessoa que utiliza o app para registrar uma ocorrência de fauna encontrada na rodovia ou em seu entorno.

**Objetivo:** registrar rapidamente um atropelamento ou avistamento com foto e localização.

### 5.2. Pesquisador

Usuário técnico que poderá consultar registros para fins científicos e de monitoramento.

**Objetivo:** obter dados estruturados, georreferenciados e confiáveis.

### 5.3. Validador técnico

Usuário responsável por analisar registros enviados e confirmar ou corrigir informações.

**Objetivo:** validar espécie, consistência das fotos e dados da ocorrência.

---

## 6. Fluxo do Usuário

```text
Usuário acessa o app
        ↓
Realiza login
        ↓
Acessa a opção “Registrar ocorrência”
        ↓
Seleciona o tipo de registro:
    - Atropelamento
    - Avistamento
        ↓
Informa os dados da espécie
        ↓
Informa ou confirma data e hora
        ↓
Sistema captura latitude e longitude
        ↓
Usuário adiciona fotos
        ↓
Usuário informa condições ambientais
        ↓
Usuário revisa os dados
        ↓
Envia o registro para a API
        ↓
Sistema salva o registro como “pendente de validação”
        ↓
App exibe mensagem de sucesso
```

---

## 7. Requisitos Funcionais

### RF01 — Autenticar usuário

O sistema deve permitir que o usuário realize login antes de acessar o cadastro de ocorrências.

**Critérios de aceite:**

- O usuário deve conseguir acessar o app com credenciais válidas.
- Usuário não autenticado não deve conseguir enviar registros.
- A autenticação deve ser realizada por API própria.
- Após login, a API deve retornar um token de acesso.
- Em caso de sessão expirada, o app deve redirecionar para login.

---

### RF02 — Armazenar token de autenticação

O app deve armazenar o token de autenticação de forma segura no dispositivo.

**Critérios de aceite:**

- O token deve ser salvo em storage seguro.
- O token deve ser enviado nas requisições autenticadas.
- O app deve remover o token no logout.
- O app deve tratar erro `401 Unauthorized` redirecionando o usuário para login.

---

### RF03 — Iniciar cadastro de ocorrência

O sistema deve disponibilizar uma opção para o usuário iniciar um novo registro de fauna.

**Critérios de aceite:**

- Deve existir um botão ou item de menu chamado “Registrar ocorrência”.
- Ao acessar essa opção, o usuário deve ser direcionado para o formulário de cadastro.
- O formulário deve iniciar com data, hora e localização carregadas automaticamente quando possível.

---

### RF04 — Selecionar tipo de registro

O sistema deve permitir que o usuário selecione se a ocorrência é um **atropelamento** ou um **avistamento**.

**Critérios de aceite:**

- O campo `tipo_registro` deve ser obrigatório.
- As opções devem ser:
  - Atropelamento;
  - Avistamento.
- A seleção do tipo deve alterar os campos específicos exibidos no formulário.

---

### RF05 — Registrar dados básicos da ocorrência

O sistema deve permitir o registro dos dados principais da ocorrência.

**Campos mínimos:**

- Tipo de registro;
- Espécie ou identificação aproximada;
- Data da ocorrência;
- Hora da ocorrência;
- Observações;
- Latitude;
- Longitude.

**Critérios de aceite:**

- Data e hora devem vir preenchidas automaticamente com o momento atual.
- O usuário pode editar data e hora, caso necessário.
- Latitude e longitude devem ser capturadas automaticamente.
- O sistema deve impedir envio sem os campos obrigatórios.

---

### RF06 — Registrar espécie do animal

O sistema deve permitir que o usuário informe a espécie do animal.

**Comportamentos esperados:**

- O usuário pode selecionar uma espécie cadastrada.
- O usuário pode informar um nome aproximado.
- O usuário pode marcar como “não sei identificar”.

**Critérios de aceite:**

- O campo `id_especie` pode ser nulo.
- O campo `nome_especie_informado` deve aceitar texto livre.
- Caso o usuário não saiba identificar, o registro deve ser enviado mesmo assim.
- A validação técnica posterior poderá corrigir ou confirmar a espécie.

---

### RF07 — Capturar localização georreferenciada

O sistema deve capturar automaticamente a localização do usuário no momento do cadastro.

**Campos esperados:**

- Latitude;
- Longitude;
- Precisão da localização, se disponível.

**Critérios de aceite:**

- O app deve solicitar permissão de localização.
- Caso a permissão seja negada, o app deve exibir mensagem explicativa.
- O envio do registro deve exigir localização válida.
- A localização deve ser salva junto ao registro.

---

### RF08 — Registrar fotos da ocorrência

O sistema deve permitir que o usuário anexe uma ou mais fotos ao registro.

**Critérios de aceite:**

- O usuário deve poder tirar foto pela câmera.
- O usuário deve poder selecionar imagem da galeria, caso permitido.
- Deve ser permitida pelo menos 1 foto.
- Para atropelamento, a foto deve ser obrigatória.
- Para avistamento, a foto pode ser recomendada, mas não necessariamente obrigatória.
- As imagens devem ser enviadas para o storage definido pelo backend.
- O banco deve armazenar a URL ou caminho da imagem retornado pela API.

---

### RF09 — Registrar condições ambientais

O sistema deve permitir que o usuário informe as condições ambientais no momento da ocorrência.

**Campos recomendados:**

- Clima;
- Período do dia;
- Condição da pista;
- Luminosidade;
- Visibilidade;
- Temperatura, se disponível;
- Umidade, se disponível;
- Observação ambiental.

**Critérios de aceite:**

- O usuário deve conseguir selecionar valores pré-definidos.
- Campos como clima, condição da pista e período do dia devem ser simples e rápidos de preencher.
- Dados ambientais devem ser vinculados ao registro principal.

---

### RF10 — Registrar informações específicas de atropelamento

Quando o tipo de registro for `atropelamento`, o sistema deve exibir campos específicos.

**Campos recomendados:**

- Condição da carcaça;
- Posição do animal na via;
- Sentido da via;
- Faixa ou local da rodovia;
- Quilômetro aproximado, se conhecido.

**Critérios de aceite:**

- Esses campos devem aparecer apenas quando o tipo for atropelamento.
- A condição da carcaça deve ser obrigatória ou recomendada.
- O registro deve ser salvo na tabela de detalhes de atropelamento.

---

### RF11 — Registrar informações específicas de avistamento

Quando o tipo de registro for `avistamento`, o sistema deve exibir campos específicos.

**Campos recomendados:**

- Quantidade de indivíduos;
- Comportamento observado;
- Distância aproximada;
- Animal vivo.

**Critérios de aceite:**

- Esses campos devem aparecer apenas quando o tipo for avistamento.
- A quantidade padrão deve ser 1.
- O registro deve ser salvo na tabela de detalhes de avistamento.

---

### RF12 — Revisar dados antes do envio

O sistema deve permitir que o usuário revise os dados antes de finalizar o cadastro.

**Critérios de aceite:**

- O app deve exibir um resumo do registro.
- O usuário deve conseguir voltar e editar informações.
- O envio deve ocorrer apenas após confirmação.

---

### RF13 — Enviar registro para validação

O sistema deve salvar o registro com status inicial `pendente`.

**Critérios de aceite:**

- Todo novo registro deve ser criado com `status_validacao = pendente`.
- O registro deve ficar disponível para análise posterior.
- O app deve exibir mensagem de sucesso após envio.
- Em caso de erro, o app deve exibir mensagem clara e permitir nova tentativa.

---

## 8. Requisitos Não Funcionais

### RNF01 — Usabilidade

O fluxo de cadastro deve ser simples e rápido, adequado para uso em campo.

### RNF02 — Performance

O envio do registro deve ser eficiente, mesmo com imagens. As imagens devem ser comprimidas antes do upload, quando necessário.

### RNF03 — Segurança

Usuários não autenticados não devem conseguir enviar registros.

### RNF04 — Integridade dos dados

Registros devem ser salvos apenas se os campos mínimos obrigatórios forem informados.

### RNF05 — Georreferenciamento

A localização deve ser capturada com precisão adequada para análise espacial.

### RNF06 — Escalabilidade

A modelagem deve permitir expansão futura para dashboards, mapas, hotspots, relatórios e validação científica.

### RNF07 — Compatibilidade

A funcionalidade deve funcionar em Android e iOS.

### RNF08 — Independência de Firebase

O app não deve depender de Firebase para autenticação, banco, storage, analytics ou notificações.

---

## 9. Regras de Negócio

### RN01 — Registro exige usuário autenticado

Apenas usuários autenticados podem criar registros.

### RN02 — Tipo de registro é obrigatório

Todo registro deve ser classificado como:

- Atropelamento;
- Avistamento.

### RN03 — Localização é obrigatória

Todo registro deve conter latitude e longitude capturadas pelo aplicativo.

### RN04 — Foto é obrigatória para atropelamento

Registros de atropelamento devem conter pelo menos uma foto.

### RN05 — Espécie pode ser desconhecida

O usuário pode enviar um registro sem identificar a espécie.

### RN06 — Registro nasce pendente

Todo novo registro deve ser salvo com status inicial:

```text
pendente
```

### RN07 — Dados específicos dependem do tipo de registro

- Atropelamento deve salvar dados em `registros_atropelamento`.
- Avistamento deve salvar dados em `registros_avistamento`.

### RN08 — Usuário não pode validar o próprio registro

Caso exista módulo de validação, o validador técnico não deve validar registros próprios.

---

## 10. Modelo de Dados Recomendado

### 10.1. Tabela `usuarios`

```sql
CREATE TABLE usuarios (
    id_usuario UUID PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    perfil VARCHAR(50) DEFAULT 'usuario',
    instituicao VARCHAR(150),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 10.2. Tabela `especies`

```sql
CREATE TABLE especies (
    id_especie UUID PRIMARY KEY,
    nome_popular VARCHAR(150),
    nome_cientifico VARCHAR(150),
    grupo_taxonomico VARCHAR(80),
    classe VARCHAR(80),
    ordem_taxonomica VARCHAR(80),
    familia VARCHAR(80),
    status_conservacao VARCHAR(100),
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE
);
```

### 10.3. Tabela `registros_fauna`

```sql
CREATE TABLE registros_fauna (
    id_registro UUID PRIMARY KEY,
    id_usuario UUID NOT NULL,
    id_especie UUID,

    tipo_registro VARCHAR(30) NOT NULL,
    nome_especie_informado VARCHAR(150),

    data_ocorrencia DATE NOT NULL,
    hora_ocorrencia TIME NOT NULL,

    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    precisao_localizacao_m DECIMAL(8, 2),
    geom GEOMETRY(Point, 4326),

    rodovia VARCHAR(50),
    km_rodovia DECIMAL(8, 3),
    municipio VARCHAR(100),

    observacoes TEXT,
    status_validacao VARCHAR(30) DEFAULT 'pendente',

    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP,

    CONSTRAINT fk_registro_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),

    CONSTRAINT fk_registro_especie
        FOREIGN KEY (id_especie) REFERENCES especies(id_especie)
);
```

### 10.4. Tabela `registros_atropelamento`

```sql
CREATE TABLE registros_atropelamento (
    id_atropelamento UUID PRIMARY KEY,
    id_registro UUID NOT NULL,

    condicao_carcaca VARCHAR(80),
    posicao_animal VARCHAR(100),
    sentido_via VARCHAR(50),
    faixa_rodovia VARCHAR(50),

    CONSTRAINT fk_atropelamento_registro
        FOREIGN KEY (id_registro) REFERENCES registros_fauna(id_registro)
);
```

### 10.5. Tabela `registros_avistamento`

```sql
CREATE TABLE registros_avistamento (
    id_avistamento UUID PRIMARY KEY,
    id_registro UUID NOT NULL,

    quantidade_individuos INTEGER DEFAULT 1,
    comportamento_observado VARCHAR(100),
    distancia_aproximada_m DECIMAL(8, 2),
    animal_vivo BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_avistamento_registro
        FOREIGN KEY (id_registro) REFERENCES registros_fauna(id_registro)
);
```

### 10.6. Tabela `fotos_registro`

```sql
CREATE TABLE fotos_registro (
    id_foto UUID PRIMARY KEY,
    id_registro UUID NOT NULL,

    url_foto TEXT NOT NULL,
    tipo_foto VARCHAR(50),
    ordem INTEGER DEFAULT 1,

    latitude_exif DECIMAL(10, 8),
    longitude_exif DECIMAL(11, 8),
    data_captura_exif TIMESTAMP,

    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_foto_registro
        FOREIGN KEY (id_registro) REFERENCES registros_fauna(id_registro)
);
```

### 10.7. Tabela `dados_ambientais`

```sql
CREATE TABLE dados_ambientais (
    id_ambiental UUID PRIMARY KEY,
    id_registro UUID NOT NULL,

    clima VARCHAR(80),
    periodo_dia VARCHAR(50),
    temperatura_c DECIMAL(5, 2),
    umidade_percentual DECIMAL(5, 2),
    precipitacao_mm DECIMAL(8, 2),

    condicao_pista VARCHAR(80),
    luminosidade VARCHAR(80),
    visibilidade VARCHAR(80),

    observacao_ambiental TEXT,

    CONSTRAINT fk_ambiental_registro
        FOREIGN KEY (id_registro) REFERENCES registros_fauna(id_registro)
);
```

### 10.8. Tabela `validacoes`

```sql
CREATE TABLE validacoes (
    id_validacao UUID PRIMARY KEY,
    id_registro UUID NOT NULL,
    id_validador UUID NOT NULL,

    status VARCHAR(30) NOT NULL,
    comentario TEXT,
    nivel_confianca INTEGER,

    especie_corrigida UUID,
    data_validacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_validacao_registro
        FOREIGN KEY (id_registro) REFERENCES registros_fauna(id_registro),

    CONSTRAINT fk_validacao_validador
        FOREIGN KEY (id_validador) REFERENCES usuarios(id_usuario),

    CONSTRAINT fk_validacao_especie
        FOREIGN KEY (especie_corrigida) REFERENCES especies(id_especie)
);
```

---

## 11. Enumerações Recomendadas

### 11.1. Tipo de registro

```text
atropelamento
avistamento
```

### 11.2. Status de validação

```text
pendente
validado
rejeitado
em_revisao
```

### 11.3. Condição da carcaça

```text
inteira
parcial
decomposta
nao_identificavel
```

### 11.4. Condição da pista

```text
seca
molhada
alagada
com_barro
nao_informado
```

### 11.5. Clima

```text
ensolarado
nublado
chuvoso
neblina
nao_informado
```

### 11.6. Período do dia

```text
manha
tarde
noite
madrugada
```

---

## 12. Contrato de API

### 12.1. Login

**Endpoint:**

```http
POST /api/auth/login
```

**Request:**

```json
{
  "email": "usuario@email.com",
  "senha": "senha-do-usuario"
}
```

**Response:**

```json
{
  "accessToken": "jwt-token",
  "refreshToken": "refresh-token",
  "usuario": {
    "idUsuario": "uuid-do-usuario",
    "nome": "Nome do Usuário",
    "email": "usuario@email.com",
    "perfil": "usuario"
  }
}
```

---

### 12.2. Criar registro de fauna

**Endpoint:**

```http
POST /api/registros-fauna
```

**Headers:**

```http
Authorization: Bearer <accessToken>
Content-Type: application/json
```

**Request:**

```json
{
  "tipoRegistro": "atropelamento",
  "idEspecie": "uuid-da-especie",
  "nomeEspecieInformado": "tamandua",
  "dataOcorrencia": "2026-07-02",
  "horaOcorrencia": "14:30:00",
  "latitude": 0.03456789,
  "longitude": -51.05678901,
  "precisaoLocalizacaoM": 8.5,
  "rodovia": "BR-156",
  "kmRodovia": 45.2,
  "municipio": "Macapá",
  "observacoes": "Animal encontrado próximo ao acostamento.",
  "dadosAmbientais": {
    "clima": "chuvoso",
    "periodoDia": "tarde",
    "condicaoPista": "molhada",
    "luminosidade": "claro",
    "visibilidade": "boa"
  },
  "dadosAtropelamento": {
    "condicaoCarcaca": "inteira",
    "posicaoAnimal": "acostamento",
    "sentidoVia": "norte",
    "faixaRodovia": "direita"
  },
  "dadosAvistamento": null,
  "fotos": [
    {
      "urlFoto": "https://storage.app/foto1.jpg",
      "tipoFoto": "animal",
      "ordem": 1
    }
  ]
}
```

**Response — sucesso:**

```json
{
  "idRegistro": "uuid-do-registro",
  "statusValidacao": "pendente",
  "message": "Registro enviado com sucesso."
}
```

---

### 12.3. Upload de foto

**Endpoint:**

```http
POST /api/registros-fauna/fotos/upload
```

**Headers:**

```http
Authorization: Bearer <accessToken>
Content-Type: multipart/form-data
```

**Campos:**

```text
file
idRegistro
tipoFoto
```

**Response:**

```json
{
  "urlFoto": "https://storage.app/foto1.jpg"
}
```

---

### 12.4. Listar espécies

**Endpoint:**

```http
GET /api/especies
```

**Headers:**

```http
Authorization: Bearer <accessToken>
```

**Response:**

```json
[
  {
    "idEspecie": "uuid",
    "nomePopular": "Tamanduá-mirim",
    "nomeCientifico": "Tamandua tetradactyla",
    "grupoTaxonomico": "Mamífero"
  }
]
```

---

## 13. Estrutura Recomendada no Flutter

```text
lib/
  core/
    auth/
      auth_token_storage.dart
      auth_interceptor.dart
    network/
      api_client.dart
      dio_client.dart
    errors/
      failure.dart
      exceptions.dart
    permissions/
      location_permission_service.dart
      camera_permission_service.dart

  features/
    auth/
      data/
        datasources/
          auth_remote_datasource.dart
        models/
          login_request_model.dart
          login_response_model.dart
          user_model.dart
        repositories/
          auth_repository_impl.dart
      domain/
        entities/
          authenticated_user.dart
        repositories/
          auth_repository.dart
        usecases/
          login_usecase.dart
          logout_usecase.dart
      presentation/
        cubit/
          auth_cubit.dart
          auth_state.dart
        pages/
          login_page.dart

    wildlife_record/
      data/
        datasources/
          wildlife_record_remote_datasource.dart
        models/
          wildlife_record_model.dart
          environmental_data_model.dart
          roadkill_details_model.dart
          sighting_details_model.dart
          record_photo_model.dart
        repositories/
          wildlife_record_repository_impl.dart
      domain/
        entities/
          wildlife_record.dart
          environmental_data.dart
          roadkill_details.dart
          sighting_details.dart
          record_photo.dart
        repositories/
          wildlife_record_repository.dart
        usecases/
          create_wildlife_record_usecase.dart
          upload_record_photo_usecase.dart
          get_species_usecase.dart
      presentation/
        cubit/
          wildlife_record_cubit.dart
          wildlife_record_state.dart
        pages/
          wildlife_record_form_page.dart
          wildlife_record_review_page.dart
        widgets/
          record_type_selector.dart
          species_selector.dart
          location_section.dart
          environmental_data_form.dart
          roadkill_details_form.dart
          sighting_details_form.dart
          photo_picker_section.dart
```

---

## 14. Pacotes Flutter Recomendados

```yaml
dependencies:
  flutter_bloc: ^latest
  equatable: ^latest
  get_it: ^latest
  dio: ^latest
  dartz: ^latest
  geolocator: ^latest
  image_picker: ^latest
  permission_handler: ^latest
  flutter_secure_storage: ^latest
  intl: ^latest
```

### Observação

Não adicionar dependências Firebase, como:

```yaml
firebase_core
firebase_auth
firebase_storage
cloud_firestore
firebase_messaging
firebase_crashlytics
```

---

## 15. Entidades Flutter

### 15.1. Enum de tipo de registro

```dart
enum WildlifeRecordType {
  roadkill,
  sighting;

  String get apiValue {
    switch (this) {
      case WildlifeRecordType.roadkill:
        return 'atropelamento';
      case WildlifeRecordType.sighting:
        return 'avistamento';
    }
  }
}
```

### 15.2. Entidade principal

```dart
class WildlifeRecord {
  final String id;
  final String userId;
  final WildlifeRecordType type;
  final String? speciesId;
  final String? informedSpeciesName;
  final DateTime occurrenceDateTime;
  final double latitude;
  final double longitude;
  final double? locationAccuracy;
  final String? road;
  final double? roadKm;
  final String? city;
  final String? notes;
  final String validationStatus;

  const WildlifeRecord({
    required this.id,
    required this.userId,
    required this.type,
    this.speciesId,
    this.informedSpeciesName,
    required this.occurrenceDateTime,
    required this.latitude,
    required this.longitude,
    this.locationAccuracy,
    this.road,
    this.roadKm,
    this.city,
    this.notes,
    this.validationStatus = 'pendente',
  });
}
```

### 15.3. Dados ambientais

```dart
class EnvironmentalData {
  final String? weather;
  final String? dayPeriod;
  final double? temperature;
  final double? humidity;
  final double? precipitation;
  final String? roadCondition;
  final String? luminosity;
  final String? visibility;
  final String? notes;

  const EnvironmentalData({
    this.weather,
    this.dayPeriod,
    this.temperature,
    this.humidity,
    this.precipitation,
    this.roadCondition,
    this.luminosity,
    this.visibility,
    this.notes,
  });
}
```

### 15.4. Detalhes de atropelamento

```dart
class RoadkillDetails {
  final String? carcassCondition;
  final String? animalPosition;
  final String? roadDirection;
  final String? roadLane;

  const RoadkillDetails({
    this.carcassCondition,
    this.animalPosition,
    this.roadDirection,
    this.roadLane,
  });
}
```

### 15.5. Detalhes de avistamento

```dart
class SightingDetails {
  final int quantity;
  final String? observedBehavior;
  final double? approximateDistance;
  final bool animalAlive;

  const SightingDetails({
    this.quantity = 1,
    this.observedBehavior,
    this.approximateDistance,
    this.animalAlive = true,
  });
}
```

---

## 16. Estado com Cubit

### 16.1. Estados esperados

```text
initial
loadingLocation
locationLoaded
locationFailure
uploadingPhoto
photoUploaded
saving
success
failure
```

### 16.2. Responsabilidades do Cubit

O `WildlifeRecordCubit` deve:

- Controlar o tipo de registro selecionado.
- Capturar localização.
- Armazenar dados temporários do formulário.
- Validar campos obrigatórios.
- Controlar fotos selecionadas.
- Realizar upload das fotos.
- Enviar o registro ao backend.
- Emitir estado de sucesso ou erro.

---

## 17. Validações no App

### 17.1. Validações gerais

| Campo | Regra |
|---|---|
| Tipo de registro | Obrigatório |
| Data | Obrigatória |
| Hora | Obrigatória |
| Latitude | Obrigatória |
| Longitude | Obrigatória |
| Espécie | Pode ser nula se houver descrição livre |
| Foto | Obrigatória para atropelamento |
| Condições ambientais | Recomendadas |

### 17.2. Validação para atropelamento

| Campo | Regra |
|---|---|
| Foto | Obrigatória |
| Condição da carcaça | Recomendada |
| Posição do animal | Recomendada |

### 17.3. Validação para avistamento

| Campo | Regra |
|---|---|
| Quantidade de indivíduos | Obrigatória, padrão 1 |
| Foto | Recomendada |
| Comportamento observado | Recomendado |

---

## 18. Telas Necessárias

### 18.1. Tela de Login

Permite autenticação do usuário por API própria.

### 18.2. Tela Inicial

Deve possuir botão de acesso rápido:

```text
Registrar ocorrência
```

### 18.3. Tela de Cadastro de Ocorrência

Contém o formulário principal.

Seções recomendadas:

```text
1. Tipo de registro
2. Espécie
3. Data e hora
4. Localização
5. Fotos
6. Condições ambientais
7. Dados específicos
8. Observações
```

### 18.4. Tela de Revisão

Exibe o resumo antes do envio.

### 18.5. Tela de Sucesso

Exibe confirmação:

```text
Registro enviado com sucesso.
Seu registro ficará pendente até validação técnica.
```

---

## 19. Tratamento de Erros

### 19.1. Erro de localização

```text
Não foi possível obter sua localização. Verifique se a permissão de localização está ativada e tente novamente.
```

### 19.2. Erro de câmera

```text
Não foi possível acessar a câmera. Verifique as permissões do aplicativo.
```

### 19.3. Erro de envio

```text
Não foi possível enviar o registro. Verifique sua conexão e tente novamente.
```

### 19.4. Campos obrigatórios

```text
Preencha os campos obrigatórios antes de continuar.
```

### 19.5. Sessão expirada

```text
Sua sessão expirou. Faça login novamente para continuar.
```

---

## 20. Permissões Necessárias

### Android

```text
ACCESS_FINE_LOCATION
ACCESS_COARSE_LOCATION
CAMERA
READ_MEDIA_IMAGES
```

### iOS

```text
NSLocationWhenInUseUsageDescription
NSCameraUsageDescription
NSPhotoLibraryUsageDescription
```

---

## 21. Critérios Gerais de Aceite

A implementação será considerada concluída quando:

- O usuário conseguir logar no app usando API própria.
- O token for armazenado de forma segura.
- O usuário conseguir iniciar um novo registro.
- O usuário conseguir escolher entre atropelamento e avistamento.
- O app capturar latitude e longitude.
- O usuário conseguir anexar fotos.
- O upload for realizado sem Firebase.
- O usuário conseguir informar espécie ou marcar como desconhecida.
- O usuário conseguir preencher condições ambientais.
- O app validar campos obrigatórios.
- O app enviar os dados ao backend.
- O registro for salvo com status `pendente`.
- O app exibir confirmação de sucesso.
- Em caso de erro, o app exibir mensagem amigável.

---

## 22. Histórias de Usuário

### HU01 — Realizar login

Eu como usuário  
Quero acessar o aplicativo com minhas credenciais  
Para conseguir registrar ocorrências de fauna.

**Critérios de aceite:**

- Deve existir tela de login.
- Deve haver validação de credenciais por API própria.
- Usuário autenticado deve acessar a tela inicial.
- Usuário não autenticado não deve enviar registros.

---

### HU02 — Registrar ocorrência de fauna

Eu como usuário  
Quero registrar uma ocorrência de fauna  
Para contribuir com o monitoramento ambiental da rodovia.

**Critérios de aceite:**

- Deve existir opção “Registrar ocorrência”.
- O usuário deve selecionar o tipo de registro.
- O sistema deve salvar os dados informados.

---

### HU03 — Registrar atropelamento

Eu como usuário  
Quero registrar um animal atropelado  
Para contribuir com o mapeamento de áreas críticas de atropelamento.

**Critérios de aceite:**

- O usuário deve selecionar o tipo `atropelamento`.
- O app deve exigir localização.
- O app deve exigir pelo menos uma foto.
- O app deve permitir informar condição da carcaça.
- O registro deve ser salvo como pendente.

---

### HU04 — Registrar avistamento

Eu como usuário  
Quero registrar um animal avistado  
Para contribuir com o monitoramento da presença de fauna na região.

**Critérios de aceite:**

- O usuário deve selecionar o tipo `avistamento`.
- O app deve exigir localização.
- O app deve permitir informar quantidade de indivíduos.
- O app deve permitir informar comportamento observado.
- O registro deve ser salvo como pendente.

---

### HU05 — Capturar localização

Eu como usuário  
Quero que o app capture minha localização automaticamente  
Para que o registro seja georreferenciado corretamente.

**Critérios de aceite:**

- O app deve solicitar permissão de localização.
- O app deve capturar latitude e longitude.
- O app deve informar erro caso não consiga obter localização.

---

### HU06 — Anexar fotos

Eu como usuário  
Quero adicionar fotos ao registro  
Para documentar a ocorrência observada.

**Critérios de aceite:**

- O usuário deve poder tirar foto.
- O usuário deve poder selecionar imagem da galeria.
- O sistema deve vincular as fotos ao registro.
- Para atropelamento, deve haver pelo menos uma foto.

---

### HU07 — Informar condições ambientais

Eu como usuário  
Quero informar as condições ambientais  
Para enriquecer a qualidade científica do registro.

**Critérios de aceite:**

- O usuário deve poder informar clima, período do dia, condição da pista, luminosidade e visibilidade.
- Os dados ambientais devem ser salvos vinculados ao registro.

---

## 23. Roadmap Técnico de Implementação

### Etapa 1 — Estrutura da feature

- Criar módulo `wildlife_record`.
- Criar entidades de domínio.
- Criar models.
- Criar repository.
- Criar datasource.
- Criar usecases.
- Criar cubit.

### Etapa 2 — Autenticação

- Criar módulo `auth`.
- Implementar login via API.
- Armazenar token com `flutter_secure_storage`.
- Criar interceptor do Dio para enviar `Authorization: Bearer`.
- Tratar sessão expirada.

### Etapa 3 — Tela de formulário

- Criar tela de cadastro.
- Criar seletor de tipo de registro.
- Criar seção de espécie.
- Criar seção de data/hora.
- Criar seção de localização.
- Criar seção de fotos.
- Criar seção ambiental.
- Criar campos específicos por tipo.

### Etapa 4 — Localização

- Configurar permissões.
- Capturar latitude e longitude.
- Tratar erros de permissão.
- Exibir localização no formulário.

### Etapa 5 — Fotos

- Configurar câmera/galeria.
- Selecionar imagens.
- Exibir prévia.
- Realizar upload pela API.
- Salvar URLs retornadas pelo backend.

### Etapa 6 — Envio

- Montar payload.
- Validar formulário.
- Enviar para API.
- Tratar sucesso e erro.

### Etapa 7 — Testes

- Testar login.
- Testar armazenamento de token.
- Testar seleção de tipo.
- Testar validações obrigatórias.
- Testar localização.
- Testar upload de fotos.
- Testar envio de atropelamento.
- Testar envio de avistamento.
- Testar erro de conexão.
- Testar permissão negada.
- Testar sessão expirada.

---

## 24. Definition of Done

A entrega será considerada pronta quando:

- Código estiver organizado seguindo Clean Architecture.
- O app não possuir dependências Firebase.
- Cubit controlar corretamente os estados.
- Formulário funcionar para atropelamento e avistamento.
- Localização for capturada corretamente.
- Fotos forem anexadas e enviadas por API própria.
- Payload estiver compatível com o backend.
- Token de autenticação for salvo de forma segura.
- Testes unitários principais forem criados.
- Fluxo for validado em Android.
- Fluxo for validado em iOS, se disponível.
- Não houver crashes no fluxo principal.
- Usuário receber feedback claro em sucesso e erro.

---

## 25. Observações Técnicas

Para esta primeira versão, recomenda-se manter o fluxo simples, priorizando:

- Cadastro rápido;
- Localização automática;
- Foto obrigatória para atropelamento;
- Status pendente;
- Campos ambientais simples;
- Estrutura preparada para validação posterior;
- Backend próprio sem Firebase.

A arquitetura deve permitir evolução futura para:

- Modo offline;
- Sincronização posterior;
- Mapa de registros;
- Validação científica;
- Dashboard web;
- Relatórios;
- Hotspots;
- Hot moments;
- Gamificação educativa.
