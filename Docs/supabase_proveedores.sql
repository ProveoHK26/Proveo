-- SQL para Supabase Proveo
-- Ejecuta esto en Supabase > SQL Editor

create extension if not exists pgcrypto;

do $$
begin
  if to_regclass('public.suppliers') is null then
    create table public.suppliers (
      id uuid primary key default gen_random_uuid(),
      user_id uuid references auth.users(id) on delete cascade,
      name text not null,
      contact_name text default '',
      email text default '',
      phone text default '',
      category text default '',
      specialty text default '',
      rating text default '4.7',
      description text default '',
      created_at timestamptz not null default now(),
      updated_at timestamptz not null default now()
    );
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'contact_name'
  ) then
    alter table public.suppliers add column contact_name text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'email'
  ) then
    alter table public.suppliers add column email text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'phone'
  ) then
    alter table public.suppliers add column phone text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'category'
  ) then
    alter table public.suppliers add column category text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'specialty'
  ) then
    alter table public.suppliers add column specialty text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'rating'
  ) then
    alter table public.suppliers add column rating text default '4.7';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'description'
  ) then
    alter table public.suppliers add column description text default '';
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'created_at'
  ) then
    alter table public.suppliers add column created_at timestamptz not null default now();
  end if;

  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public' and table_name = 'suppliers' and column_name = 'updated_at'
  ) then
    alter table public.suppliers add column updated_at timestamptz not null default now();
  end if;
end
$$;

alter table public.suppliers enable row level security;

create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists update_suppliers_updated_at on public.suppliers;
create trigger update_suppliers_updated_at
before update on public.suppliers
for each row execute function public.update_updated_at_column();

drop policy if exists "suppliers_select_all" on public.suppliers;
create policy "suppliers_select_all"
on public.suppliers for select
using (true);

drop policy if exists "suppliers_insert_all" on public.suppliers;
create policy "suppliers_insert_all"
on public.suppliers for insert
with check (true);

drop policy if exists "suppliers_update_all" on public.suppliers;
create policy "suppliers_update_all"
on public.suppliers for update
using (true)
with check (true);

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.suppliers to anon, authenticated;

insert into public.suppliers (name, contact_name, email, phone, category, specialty, rating, description)
values
('Northwind Ltd.', 'Carlos Vega', 'carlos.vega@northwind.com', '+34 600 111 222', 'Logística', 'Transporte y distribución', '4.9', 'Empresa especializada en movilidad operativa y logística de última milla.'),
('BluePeak', 'Marta Ruiz', 'marta.ruiz@bluepeak.com', '+34 610 222 333', 'Tecnología', 'Hardware y equipos', '4.8', 'Proveedor de hardware y soluciones tecnológicas para operaciones modernas.'),
('Acme Supplies', 'Laura Pérez', 'laura.perez@acme.com', '+34 620 333 444', 'Materiales', 'Materias primas industriales', '4.7', 'Suministra materiales para producción y mantenimiento industrial.'),
('EcoFlex SA', 'Javier Soler', 'javier@ecoflex.es', '+34 630 444 555', 'Sostenibilidad', 'Packaging ecológico', '4.9', 'Especialista en envases sostenibles y soluciones verdes.'),
('PrimeSource', 'Elena Torres', 'elena@primesource.es', '+34 640 555 666', 'Compras', 'Componentes de oficina', '4.6', 'Proveedor de productos de oficina con servicio ágil y especializado.'),
('MecanoWork', 'Pedro Ibarra', 'pedro@mecanowork.es', '+34 650 666 777', 'Mecánica', 'Piezas industriales', '4.8', 'Compañía enfocada en piezas y repuestos industriales.'),
('Delta Industrial', 'Sofía Ramos', 'sofia@deltaindustrial.es', '+34 660 777 888', 'Producción', 'Herramientas y mantenimiento', '4.5', 'Proveedor de herramientas y soporte productivo para fábricas.'),
('Vita Goods', 'Nicolás Ortega', 'nicolas@vitagoods.es', '+34 670 888 999', 'Consumibles', 'Productos de limpieza', '4.7', 'Empresa de suministros de limpieza y mantenimiento.'),
('Atlas Logistics', 'Mireia Gómez', 'mireia@atlaslogistics.es', '+34 680 999 000', 'Logística', 'Transporte urgente', '4.9', 'Especialista en transporte express y distribución urgente.'),
('UrbanTech', 'Iñigo Castro', 'inigo@urbantech.es', '+34 690 000 111', 'Tecnología', 'Monitores y periféricos', '4.8', 'Proveedor de equipos tecnológicos para oficinas y operaciones.'),
('GreenPack', 'Ana Belmonte', 'ana@greenpack.es', '+34 700 111 222', 'Packaging', 'Envases y embalaje', '4.6', 'Proveedor de embalaje corporativo y protección de mercancía.'),
('Nova Supplies', 'Rubén Flores', 'ruben@novasupplies.es', '+34 710 222 333', 'Operaciones', 'Suministros de oficina', '4.7', 'Especialista en aprovisionamiento de oficina y operaciones diarias.');
